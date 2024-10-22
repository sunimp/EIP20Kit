//
//  TransactionManager.swift
//  EIP20Kit
//
//  Created by Sun on 2019/4/18.
//

import Combine
import Foundation

import BigInt
import EVMKit

// MARK: - TransactionManager

class TransactionManager {
    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()

    private let evmKit: EVMKit.Kit
    private let contractAddress: Address
    private let contractMethodFactories: EIP20ContractMethodFactories
    private let address: Address
    private let tagQueries: [TransactionTagQuery]

    private let transactionsSubject = PassthroughSubject<[FullTransaction], Never>()

    // MARK: Computed Properties

    var transactionsPublisher: AnyPublisher<[FullTransaction], Never> {
        transactionsSubject.eraseToAnyPublisher()
    }

    // MARK: Lifecycle

    init(evmKit: EVMKit.Kit, contractAddress: Address, contractMethodFactories: EIP20ContractMethodFactories) {
        self.evmKit = evmKit
        self.contractAddress = contractAddress
        self.contractMethodFactories = contractMethodFactories

        address = evmKit.receiveAddress
        tagQueries = [TransactionTagQuery(contractAddress: contractAddress)]

        evmKit.transactionsPublisher(tagQueries: [TransactionTagQuery(contractAddress: contractAddress)])
            .sink { [weak self] in
                self?.processTransactions(eip20Transactions: $0)
            }
            .store(in: &cancellables)
    }

    // MARK: Functions

    private func processTransactions(eip20Transactions: [FullTransaction]) {
        guard !eip20Transactions.isEmpty else {
            return
        }

        transactionsSubject.send(eip20Transactions)
    }
}

// MARK: ITransactionManager

extension TransactionManager: ITransactionManager {
    func transactions(from hash: Data?, limit: Int?) -> [FullTransaction] {
        evmKit.transactions(tagQueries: tagQueries, fromHash: hash, limit: limit)
    }

    func pendingTransactions() -> [FullTransaction] {
        evmKit.pendingTransactions(tagQueries: tagQueries)
    }

    func transferTransactionData(to: Address, value: BigUInt) -> TransactionData {
        TransactionData(
            to: contractAddress,
            value: BigUInt.zero,
            input: TransferMethod(to: to, value: value).encodedABI()
        )
    }
}
