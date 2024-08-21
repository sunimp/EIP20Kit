//
//  ApproveMethodFactory.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class ApproveMethodFactory: IContractMethodFactory {
    let methodId: Data = ContractMethodHelper.methodId(signature: ApproveMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let spender = Address(raw: inputArguments[12 ..< 32])
        let value = BigUInt(inputArguments[32 ..< 64])

        return ApproveMethod(spender: spender, value: value)
    }
}
