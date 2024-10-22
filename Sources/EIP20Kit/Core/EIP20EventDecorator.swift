//
//  EIP20EventDecorator.swift
//  EIP20Kit
//
//  Created by Sun on 2024/9/2.
//

import Foundation

import EVMKit

// MARK: - EIP20EventDecorator

class EIP20EventDecorator {
    // MARK: Properties

    private let userAddress: Address
    private let storage: EIP20Storage

    // MARK: Lifecycle

    init(userAddress: Address, storage: EIP20Storage) {
        self.userAddress = userAddress
        self.storage = storage
    }
}

// MARK: IEventDecorator

extension EIP20EventDecorator: IEventDecorator {
    public func contractEventInstancesMap(transactions: [Transaction]) -> [Data: [ContractEventInstance]] {
        let events: [Event]

        if transactions.count > 100 {
            events = storage.events()
        } else {
            let hashes = transactions.map(\.hash)
            events = storage.events(hashes: hashes)
        }

        var map = [Data: [ContractEventInstance]]()

        for event in events {
            let eventInstance = TransferEventInstance(
                contractAddress: event.contractAddress,
                from: event.from,
                to: event.to,
                value: event.value,
                tokenInfo: TokenInfo(
                    tokenName: event.tokenName,
                    tokenSymbol: event.tokenSymbol,
                    tokenDecimal: event.tokenDecimal
                )
            )

            map[event.hash] = (map[event.hash] ?? []) + [eventInstance]
        }

        return map
    }

    public func contractEventInstances(logs: [TransactionLog]) -> [ContractEventInstance] {
        logs.compactMap { log -> ContractEventInstance? in
            guard let eventInstance = log.eip20EventInstance else {
                return nil
            }

            switch eventInstance {
            case let transfer as TransferEventInstance:
                if transfer.from == userAddress || transfer.to == userAddress {
                    return eventInstance
                }

            case let approve as ApproveEventInstance:
                if approve.owner == userAddress || approve.spender == userAddress {
                    return eventInstance
                }

            default: ()
            }

            return nil
        }
    }
}
