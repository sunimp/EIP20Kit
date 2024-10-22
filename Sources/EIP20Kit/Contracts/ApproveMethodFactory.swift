//
//  ApproveMethodFactory.swift
//  EIP20Kit
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EVMKit

class ApproveMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: ApproveMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let spender = Address(raw: inputArguments[12 ..< 32])
        let value = BigUInt(inputArguments[32 ..< 64])

        return ApproveMethod(spender: spender, value: value)
    }
}
