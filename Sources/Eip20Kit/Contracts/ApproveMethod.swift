//
//  ApproveMethod.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class ApproveMethod: ContractMethod {
    static let methodSignature = "approve(address,uint256)"

    let spender: Address
    let value: BigUInt

    init(spender: Address, value: BigUInt) {
        self.spender = spender
        self.value = value

        super.init()
    }

    override var methodSignature: String { ApproveMethod.methodSignature }
    override var arguments: [Any] { [spender, value] }
}
