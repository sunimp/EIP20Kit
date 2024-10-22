//
//  AllowanceManager.swift
//  EIP20Kit
//
//  Created by Sun on 2020/7/28.
//

import Foundation

import BigInt
import EVMKit
import SWCryptoKit

// MARK: - AllowanceParsingError

enum AllowanceParsingError: Error {
    case notFound
}

// MARK: - AllowanceManager

class AllowanceManager {
    // MARK: Properties

    private let evmKit: EVMKit.Kit
    private let contractAddress: Address
    private let address: Address

    // MARK: Lifecycle

    init(evmKit: EVMKit.Kit, contractAddress: Address, address: Address) {
        self.evmKit = evmKit
        self.contractAddress = contractAddress
        self.address = address
    }

    // MARK: Functions

    func allowance(spenderAddress: Address, defaultBlockParameter: DefaultBlockParameter) async throws -> BigUInt {
        let methodData = AllowanceMethod(owner: address, spender: spenderAddress).encodedABI()
        let data = try await evmKit.fetchCall(
            contractAddress: contractAddress,
            data: methodData,
            defaultBlockParameter: defaultBlockParameter
        )
        return BigUInt(data[0 ... 31])
    }

    func approveTransactionData(spenderAddress: Address, amount: BigUInt) -> TransactionData {
        TransactionData(
            to: contractAddress,
            value: BigUInt.zero,
            input: ApproveMethod(spender: spenderAddress, value: amount).encodedABI()
        )
    }
}
