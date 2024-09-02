//
//  ApproveEIP20Decoration.swift
//
//  Created by Sun on 2024/9/2.
//

import Foundation

import BigInt
import EVMKit

public class ApproveEIP20Decoration: TransactionDecoration {
    // MARK: Properties

    public let contractAddress: Address
    public let spender: Address
    public let value: BigUInt

    // MARK: Lifecycle

    init(contractAddress: Address, spender: Address, value: BigUInt) {
        self.contractAddress = contractAddress
        self.spender = spender
        self.value = value

        super.init()
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .approve, protocol: .eip20, contractAddress: contractAddress),
        ]
    }
}
