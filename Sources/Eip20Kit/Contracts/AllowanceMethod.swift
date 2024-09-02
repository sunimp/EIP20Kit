//
//  AllowanceMethod.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import EvmKit

class AllowanceMethod: ContractMethod {
    // MARK: Overridden Properties

    override var methodSignature: String { "allowance(address,address)" }
    override var arguments: [Any] { [owner, spender] }

    // MARK: Properties

    private let owner: Address
    private let spender: Address

    // MARK: Lifecycle

    init(owner: Address, spender: Address) {
        self.owner = owner
        self.spender = spender

        super.init()
    }
}
