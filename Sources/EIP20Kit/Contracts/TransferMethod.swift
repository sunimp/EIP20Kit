//
//  TransferMethod.swift
//
//  Created by Sun on 2024/9/2.
//

import Foundation

import BigInt
import EVMKit

class TransferMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "transfer(address,uint256)"

    // MARK: Overridden Properties

    override var methodSignature: String { TransferMethod.methodSignature }
    override var arguments: [Any] { [to, value] }

    // MARK: Properties

    let to: Address
    let value: BigUInt

    // MARK: Lifecycle

    init(to: Address, value: BigUInt) {
        self.to = to
        self.value = value

        super.init()
    }
}