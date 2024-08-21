//
//  AllowanceMethod.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class AllowanceMethod: ContractMethod {
    private let owner: Address
    private let spender: Address

    init(owner: Address, spender: Address) {
        self.owner = owner
        self.spender = spender

        super.init()
    }

    override var methodSignature: String { "allowance(address,address)" }
    override var arguments: [Any] { [owner, spender] }
}
