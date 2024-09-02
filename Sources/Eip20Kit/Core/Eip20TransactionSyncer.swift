//
//  Eip20TransactionSyncer.swift
//
//  Created by Sun on 2021/1/5.
//

import Foundation

import BigInt
import EvmKit

// MARK: - Eip20TransactionSyncer

class Eip20TransactionSyncer {
    // MARK: Properties

    private let provider: ITransactionProvider
    private let storage: Eip20Storage

    // MARK: Lifecycle

    init(provider: ITransactionProvider, storage: Eip20Storage) {
        self.provider = provider
        self.storage = storage
    }

    // MARK: Functions

    private func handle(transactions: [ProviderTokenTransaction]) {
        guard !transactions.isEmpty else {
            return
        }

        let events = transactions.map { tx in
            Event(
                hash: tx.hash,
                blockNumber: tx.blockNumber,
                contractAddress: tx.contractAddress,
                from: tx.from,
                to: tx.to,
                value: tx.value,
                tokenName: tx.tokenName,
                tokenSymbol: tx.tokenSymbol,
                tokenDecimal: tx.tokenDecimal
            )
        }

        storage.save(events: events)
    }
}

// MARK: ITransactionSyncer

extension Eip20TransactionSyncer: ITransactionSyncer {
    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = storage.lastEvent()?.blockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            let transactions = try await provider.tokenTransactions(startBlock: lastBlockNumber + 1)

            handle(transactions: transactions)

            let array = transactions.map { tx in
                Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: false,
                    blockNumber: tx.blockNumber,
                    transactionIndex: tx.transactionIndex,
                    nonce: tx.nonce,
                    gasPrice: tx.gasPrice,
                    gasLimit: tx.gasLimit,
                    gasUsed: tx.gasUsed
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
}
