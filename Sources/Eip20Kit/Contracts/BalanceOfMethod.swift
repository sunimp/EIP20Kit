//
//  BalanceOfMethod.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class BalanceOfMethod: ContractMethod {
    private let owner: Address

    init(owner: Address) {
        self.owner = owner
    }

    override var methodSignature: String { "balanceOf(address)" }
    override var arguments: [Any] { [owner] }
}
