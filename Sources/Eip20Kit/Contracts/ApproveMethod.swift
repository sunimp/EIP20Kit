//
//  ApproveMethod.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EvmKit

class ApproveMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "approve(address,uint256)"

    // MARK: Overridden Properties

    override var methodSignature: String { ApproveMethod.methodSignature }
    override var arguments: [Any] { [spender, value] }

    // MARK: Properties

    let spender: Address
    let value: BigUInt

    // MARK: Lifecycle

    init(spender: Address, value: BigUInt) {
        self.spender = spender
        self.value = value

        super.init()
    }
}
