//
//  ApproveEventInstance.swift
//  EIP20Kit
//
//  Created by Sun on 2021/6/3.
//

import Foundation

import BigInt
import EVMKit

public class ApproveEventInstance: ContractEventInstance {
    // MARK: Static Properties

    static let signature = ContractEvent(name: "Approval", arguments: [.address, .address, .uint256]).signature

    // MARK: Properties

    public let owner: Address
    public let spender: Address
    public let value: BigUInt

    // MARK: Lifecycle

    init(contractAddress: Address, owner: Address, spender: Address, value: BigUInt) {
        self.owner = owner
        self.spender = spender
        self.value = value

        super.init(contractAddress: contractAddress)
    }

    // MARK: Overridden Functions

    override public func tags(userAddress _: Address) -> [TransactionTag] {
        [
            TransactionTag(type: .approve, protocol: .eip20, contractAddress: contractAddress),
        ]
    }
}
