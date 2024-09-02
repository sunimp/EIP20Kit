//
//  TransferEventInstance.swift
//
//  Created by Sun on 2021/6/17.
//

import Foundation

import BigInt
import EvmKit

// MARK: - TransferEventInstance

public class TransferEventInstance: ContractEventInstance {
    // MARK: Static Properties

    static let signature = ContractEvent(name: "Transfer", arguments: [.address, .address, .uint256]).signature

    // MARK: Properties

    public let from: Address
    public let to: Address
    public let value: BigUInt

    public let tokenInfo: TokenInfo?

    // MARK: Lifecycle

    init(contractAddress: Address, from: Address, to: Address, value: BigUInt, tokenInfo: TokenInfo? = nil) {
        self.from = from
        self.to = to
        self.value = value
        self.tokenInfo = tokenInfo

        super.init(contractAddress: contractAddress)
    }

    // MARK: Overridden Functions

    override public func tags(userAddress: Address) -> [TransactionTag] {
        var tags = [TransactionTag]()

        if from == userAddress {
            tags.append(TransactionTag(
                type: .outgoing,
                protocol: .eip20,
                contractAddress: contractAddress,
                addresses: [to.hex]
            ))
        }

        if to == userAddress {
            tags.append(TransactionTag(
                type: .incoming,
                protocol: .eip20,
                contractAddress: contractAddress,
                addresses: [from.hex]
            ))
        }

        return tags
    }
}

// MARK: - TokenInfo

public struct TokenInfo {
    public let tokenName: String
    public let tokenSymbol: String
    public let tokenDecimal: Int
}
