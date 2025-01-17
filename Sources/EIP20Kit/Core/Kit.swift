//
//  Kit.swift
//  EIP20Kit
//
//  Created by Sun on 2019/4/10.
//

import Combine
import Foundation

import BigInt
import EVMKit
import SWToolKit

// MARK: - Kit

public class Kit {
    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()

    private let contractAddress: Address
    private let evmKit: EVMKit.Kit
    private let transactionManager: ITransactionManager
    private let balanceManager: IBalanceManager
    private let allowanceManager: AllowanceManager

    private let state: KitState

    // MARK: Lifecycle

    init(
        contractAddress: Address,
        evmKit: EVMKit.Kit,
        transactionManager: ITransactionManager,
        balanceManager: IBalanceManager,
        allowanceManager: AllowanceManager,
        state: KitState = KitState()
    ) {
        self.contractAddress = contractAddress
        self.evmKit = evmKit
        self.transactionManager = transactionManager
        self.balanceManager = balanceManager
        self.allowanceManager = allowanceManager
        self.state = state

        onUpdateSyncState(syncState: evmKit.syncState)
        state.balance = balanceManager.balance

        evmKit.syncStatePublisher
            .sink { [weak self] in
                self?.onUpdateSyncState(syncState: $0)
            }
            .store(in: &cancellables)

        transactionManager.transactionsPublisher
            .sink { [weak self] _ in
                self?.balanceManager.sync()
            }
            .store(in: &cancellables)
    }

    // MARK: Functions

    private func onUpdateSyncState(syncState: EVMKit.SyncState) {
        switch syncState {
        case .synced:
            state.syncState = .syncing(progress: nil)
            balanceManager.sync()

        case .syncing:
            state.syncState = .syncing(progress: nil)

        case let .notSynced(error):
            state.syncState = .notSynced(error: error)
        }
    }
}

extension Kit {
    public func start() {
        if case .synced = evmKit.syncState {
            balanceManager.sync()
        }
    }

    public func stop() { }

    public func refresh() { }

    public var syncState: SyncState {
        state.syncState
    }

    public var transactionsSyncState: SyncState {
        evmKit.transactionsSyncState
    }

    public var balance: BigUInt? {
        state.balance
    }

    public func transactions(from hash: Data?, limit: Int?) -> [FullTransaction] {
        transactionManager.transactions(from: hash, limit: limit)
    }

    public func pendingTransactions() -> [FullTransaction] {
        transactionManager.pendingTransactions()
    }

    public var syncStatePublisher: AnyPublisher<SyncState, Never> {
        state.syncStateSubject.eraseToAnyPublisher()
    }

    public var transactionsSyncStatePublisher: AnyPublisher<SyncState, Never> {
        evmKit.transactionsSyncStatePublisher
    }

    public var balancePublisher: AnyPublisher<BigUInt, Never> {
        state.balanceSubject.eraseToAnyPublisher()
    }

    public var transactionsPublisher: AnyPublisher<[FullTransaction], Never> {
        transactionManager.transactionsPublisher
    }

    public func allowance(
        spenderAddress: Address,
        defaultBlockParameter: DefaultBlockParameter = .latest
    ) async throws
        -> String {
        try await allowanceManager.allowance(
            spenderAddress: spenderAddress,
            defaultBlockParameter: defaultBlockParameter
        )
        .description
    }

    public func approveTransactionData(spenderAddress: Address, amount: BigUInt) -> TransactionData {
        allowanceManager.approveTransactionData(spenderAddress: spenderAddress, amount: amount)
    }

    public func transferTransactionData(to: Address, value: BigUInt) -> TransactionData {
        transactionManager.transferTransactionData(to: to, value: value)
    }
}

// MARK: IBalanceManagerDelegate

extension Kit: IBalanceManagerDelegate {
    func onSyncBalanceSuccess(balance: BigUInt) {
        state.syncState = .synced
        state.balance = balance
    }

    func onSyncBalanceFailed(error: Error) {
        state.syncState = .notSynced(error: error)
    }
}

extension Kit {
    public static func instance(evmKit: EVMKit.Kit, contractAddress: Address) throws -> Kit {
        let address = evmKit.address

        let dataProvider: IDataProvider = DataProvider(evmKit: evmKit)
        let transactionManager = TransactionManager(
            evmKit: evmKit,
            contractAddress: contractAddress,
            contractMethodFactories: EIP20ContractMethodFactories.shared
        )
        let balanceManager = BalanceManager(
            storage: evmKit.eip20Storage,
            contractAddress: contractAddress,
            address: address,
            dataProvider: dataProvider
        )
        let allowanceManager = AllowanceManager(evmKit: evmKit, contractAddress: contractAddress, address: address)

        let kit = Kit(
            contractAddress: contractAddress,
            evmKit: evmKit,
            transactionManager: transactionManager,
            balanceManager: balanceManager,
            allowanceManager: allowanceManager
        )

        balanceManager.delegate = kit

        return kit
    }

    public static func addTransactionSyncer(to evmKit: EVMKit.Kit) {
        let syncer = EIP20TransactionSyncer(provider: evmKit.transactionProvider, storage: evmKit.eip20Storage)
        evmKit.add(transactionSyncer: syncer)
    }

    public static func addDecorators(to evmKit: EVMKit.Kit) {
        evmKit.add(methodDecorator: EIP20MethodDecorator(contractMethodFactories: EIP20ContractMethodFactories.shared))
        evmKit.add(eventDecorator: EIP20EventDecorator(userAddress: evmKit.address, storage: evmKit.eip20Storage))
        evmKit.add(transactionDecorator: EIP20TransactionDecorator(userAddress: evmKit.address))
    }
}

extension Kit {
    public static func tokenInfo(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        contractAddress: Address
    ) async throws
        -> TokenInfo {
        async let name = try DataProvider.fetchName(
            networkManager: networkManager,
            rpcSource: rpcSource,
            contractAddress: contractAddress
        )
        async let symbol = try DataProvider.fetchSymbol(
            networkManager: networkManager,
            rpcSource: rpcSource,
            contractAddress: contractAddress
        )
        async let decimals = try DataProvider.fetchDecimals(
            networkManager: networkManager,
            rpcSource: rpcSource,
            contractAddress: contractAddress
        )

        return try await TokenInfo(name: name, symbol: symbol, decimals: decimals)
    }
}

// MARK: Kit.TokenInfo

extension Kit {
    public struct TokenInfo {
        public let name: String
        public let symbol: String
        public let decimals: Int
    }
}
