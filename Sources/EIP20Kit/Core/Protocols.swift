//
//  Protocols.swift
//  EIP20Kit
//
//  Created by Sun on 2019/4/10.
//

import Combine
import Foundation

import BigInt
import EVMKit

// MARK: - IBalanceManagerDelegate

protocol IBalanceManagerDelegate: AnyObject {
    func onSyncBalanceSuccess(balance: BigUInt)
    func onSyncBalanceFailed(error: Error)
}

// MARK: - ITransactionManager

protocol ITransactionManager {
    var transactionsPublisher: AnyPublisher<[FullTransaction], Never> { get }

    func transactions(from hash: Data?, limit: Int?) -> [FullTransaction]
    func pendingTransactions() -> [FullTransaction]
    func transferTransactionData(to: Address, value: BigUInt) -> TransactionData
}

// MARK: - IBalanceManager

protocol IBalanceManager {
    var delegate: IBalanceManagerDelegate? { get set }

    var balance: BigUInt? { get }
    func sync()
}

// MARK: - IDataProvider

protocol IDataProvider {
    func fetchBalance(contractAddress: Address, address: Address) async throws -> BigUInt
}
