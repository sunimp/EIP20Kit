//
//  Extensions.swift
//  EIP20Kit
//
//  Created by Sun on 2021/1/8.
//

import Foundation

import BigInt
import EVMKit

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension TransactionLog {
    public var eip20EventInstance: ContractEventInstance? {
        guard topics.count == 3 else {
            return nil
        }

        let signature = topics[0]
        let firstParam = Address(raw: topics[1])
        let secondParam = Address(raw: topics[2])

        if signature == TransferEventInstance.signature {
            return TransferEventInstance(
                contractAddress: address,
                from: firstParam,
                to: secondParam,
                value: BigUInt(data)
            )
        }

        if signature == ApproveEventInstance.signature {
            return ApproveEventInstance(
                contractAddress: address,
                owner: firstParam,
                spender: secondParam,
                value: BigUInt(data)
            )
        }

        return nil
    }
}
