//
//  EIP20TransactionDecorator.swift
//  EIP20Kit
//
//  Created by Sun on 2024/9/2.
//

import Foundation

import BigInt
import EVMKit

// MARK: - EIP20TransactionDecorator

class EIP20TransactionDecorator {
    // MARK: Properties

    private let userAddress: Address

    // MARK: Lifecycle

    init(userAddress: Address) {
        self.userAddress = userAddress
    }
}

// MARK: ITransactionDecorator

extension EIP20TransactionDecorator: ITransactionDecorator {
    public func decoration(
        from: Address?,
        to: Address?,
        value: BigUInt?,
        contractMethod: ContractMethod?,
        internalTransactions _: [InternalTransaction],
        eventInstances: [ContractEventInstance]
    )
        -> TransactionDecoration? {
        guard let from, let to, let contractMethod else {
            return nil
        }

        if let transferMethod = contractMethod as? TransferMethod {
            if from == userAddress {
                return OutgoingEIP20Decoration(
                    contractAddress: to,
                    to: transferMethod.to,
                    value: transferMethod.value,
                    sentToSelf: transferMethod.to == userAddress,
                    tokenInfo: eventInstances.compactMap { $0 as? TransferEventInstance }
                        .first { $0.contractAddress == to }?
                        .tokenInfo
                )
            }
        }

        if let approveMethod = contractMethod as? ApproveMethod {
            return ApproveEIP20Decoration(
                contractAddress: to,
                spender: approveMethod.spender,
                value: approveMethod.value
            )
        }

        return nil
    }
}
