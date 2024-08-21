//
//  TransferMethod.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class TransferMethod: ContractMethod {
    static let methodSignature = "transfer(address,uint256)"

    let to: Address
    let value: BigUInt

    init(to: Address, value: BigUInt) {
        self.to = to
        self.value = value

        super.init()
    }

    override var methodSignature: String { TransferMethod.methodSignature }
    override var arguments: [Any] { [to, value] }
}
