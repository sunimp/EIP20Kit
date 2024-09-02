//
//  BalanceManager.swift
//
//  Created by Sun on 2019/4/18.
//

import Foundation

import BigInt
import EvmKit
import WWExtensions

// MARK: - BalanceManager

class BalanceManager {
    // MARK: Properties

    weak var delegate: IBalanceManagerDelegate?

    private let storage: Eip20Storage
    private let contractAddress: Address
    private let address: Address
    private let dataProvider: IDataProvider
    private var tasks = Set<AnyTask>()

    // MARK: Lifecycle

    init(storage: Eip20Storage, contractAddress: Address, address: Address, dataProvider: IDataProvider) {
        self.storage = storage
        self.contractAddress = contractAddress
        self.address = address
        self.dataProvider = dataProvider
    }

    // MARK: Functions

    private func save(balance: BigUInt) {
        storage.save(balance: balance, contractAddress: contractAddress)
    }

    private func _sync() async {
        do {
            let balance = try await dataProvider.fetchBalance(contractAddress: contractAddress, address: address)
            save(balance: balance)
            delegate?.onSyncBalanceSuccess(balance: balance)
        } catch {
            delegate?.onSyncBalanceFailed(error: error)
        }
    }
}

// MARK: IBalanceManager

extension BalanceManager: IBalanceManager {
    var balance: BigUInt? {
        storage.balance(contractAddress: contractAddress)
    }

    func sync() {
        Task { [weak self] in await self?._sync() }.store(in: &tasks)
    }
}
