import BigInt
import Combine
import EIP20Kit
import EVMKit
import Foundation
import SWExtensions

class EIP20Adapter {
    private let evmKit: EVMKit.Kit
    private let signer: Signer?
    private let eip20Kit: EIP20Kit.Kit
    private let token: EIP20Token

    init(evmKit: EVMKit.Kit, signer: Signer?, token: EIP20Token) throws {
        self.evmKit = evmKit
        self.signer = signer
        eip20Kit = try EIP20Kit.Kit.instance(evmKit: evmKit, contractAddress: token.contractAddress)
        self.token = token
    }

    private func transactionRecord(fromTransaction fullTransaction: FullTransaction) -> TransactionRecord? {
        let transaction = fullTransaction.transaction

        var amount: Decimal?

        if let value = transaction.value, let significand = Decimal(string: value.description) {
            amount = Decimal(sign: .plus, exponent: -token.decimal, significand: significand)
        }

        return TransactionRecord(
            transactionHash: transaction.hash.sw.hexString,
            transactionHashData: transaction.hash,
            timestamp: transaction.timestamp,
            isFailed: transaction.isFailed,
            from: transaction.from,
            to: transaction.to,
            amount: amount,
            input: transaction.input.map(\.sw.hexString),
            blockHeight: transaction.blockNumber,
            transactionIndex: transaction.transactionIndex,
            decoration: String(describing: fullTransaction.decoration)
        )
    }
}

extension EIP20Adapter {
    func start() {
        eip20Kit.start()
    }

    func stop() {
        eip20Kit.stop()
    }

    func refresh() {
        eip20Kit.refresh()
    }

    var name: String {
        token.name
    }

    var coin: String {
        token.code
    }

    var lastBlockHeight: Int? {
        evmKit.lastBlockHeight
    }

    var syncState: EVMKit.SyncState {
        switch eip20Kit.syncState {
        case .synced: return EVMKit.SyncState.synced
        case .syncing: return EVMKit.SyncState.syncing(progress: nil)
        case let .notSynced(error): return EVMKit.SyncState.notSynced(error: error)
        }
    }

    var transactionsSyncState: EVMKit.SyncState {
        switch eip20Kit.transactionsSyncState {
        case .synced: return EVMKit.SyncState.synced
        case .syncing: return EVMKit.SyncState.syncing(progress: nil)
        case let .notSynced(error): return EVMKit.SyncState.notSynced(error: error)
        }
    }

    var balance: Decimal {
        if let balance = eip20Kit.balance, let significand = Decimal(string: balance.description) {
            return Decimal(sign: .plus, exponent: -token.decimal, significand: significand)
        }

        return 0
    }

    var receiveAddress: Address {
        evmKit.receiveAddress
    }

    var lastBlockHeightPublisher: AnyPublisher<Void, Never> {
        evmKit.lastBlockHeightPublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var syncStatePublisher: AnyPublisher<Void, Never> {
        eip20Kit.syncStatePublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var transactionsSyncStatePublisher: AnyPublisher<Void, Never> {
        eip20Kit.transactionsSyncStatePublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var balancePublisher: AnyPublisher<Void, Never> {
        eip20Kit.balancePublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var transactionsPublisher: AnyPublisher<Void, Never> {
        eip20Kit.transactionsPublisher.map { _ in () }.eraseToAnyPublisher()
    }

    func transactions(from hash: Data?, limit: Int?) -> [TransactionRecord] {
        eip20Kit.transactions(from: hash, limit: limit)
            .compactMap {
                transactionRecord(fromTransaction: $0)
            }
    }

    func transaction(hash _: Data, interTransactionIndex _: Int) -> TransactionRecord? {
        nil
    }

    func estimatedGasLimit(to address: Address, value: Decimal, gasPrice: GasPrice) async throws -> Int {
        let value = BigUInt(value.sw.roundedString(decimal: token.decimal))!
        let transactionData = eip20Kit.transferTransactionData(to: address, value: value)

        return try await evmKit.fetchEstimateGas(transactionData: transactionData, gasPrice: gasPrice)
    }

    func fetchTransaction(hash: Data) async throws -> FullTransaction {
        try await evmKit.fetchTransaction(hash: hash)
    }

    func allowance(spenderAddress: Address) async throws -> Decimal {
        let allowanceString = try await eip20Kit.allowance(spenderAddress: spenderAddress)

        guard let significand = Decimal(string: allowanceString) else {
            return 0
        }

        return Decimal(sign: .plus, exponent: -token.decimal, significand: significand)
    }

    func send(to: Address, amount: Decimal, gasLimit: Int, gasPrice: GasPrice) async throws {
        guard let signer else {
            throw SendError.noSigner
        }

        let value = BigUInt(amount.sw.roundedString(decimal: token.decimal))!
        let transactionData = eip20Kit.transferTransactionData(to: to, value: value)

        let rawTransaction = try await evmKit.fetchRawTransaction(transactionData: transactionData, gasPrice: gasPrice, gasLimit: gasLimit)
        let signature = try signer.signature(rawTransaction: rawTransaction)

        _ = try await evmKit.send(rawTransaction: rawTransaction, signature: signature)
    }
}

extension EIP20Adapter {
    enum SendError: Error {
        case noSigner
    }
}
