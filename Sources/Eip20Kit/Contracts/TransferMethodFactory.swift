//
//  TransferMethodFactory.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EvmKit

class TransferMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: TransferMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let to = Address(raw: inputArguments[12 ..< 32])
        let value = BigUInt(inputArguments[32 ..< 64])

        return TransferMethod(to: to, value: value)
    }
}
