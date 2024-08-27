//
//  TransferMethodFactory.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class TransferMethodFactory: IContractMethodFactory {
    let methodId: Data = ContractMethodHelper.methodId(signature: TransferMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let to = Address(raw: inputArguments[12 ..< 32])
        let value = BigUInt(inputArguments[32 ..< 64])

        return TransferMethod(to: to, value: value)
    }
}
