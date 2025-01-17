//
//  BalanceOfMethod.swift
//  EIP20Kit
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import EVMKit

class BalanceOfMethod: ContractMethod {
    // MARK: Overridden Properties

    override var methodSignature: String { "balanceOf(address)" }
    override var arguments: [Any] { [owner] }

    // MARK: Properties

    private let owner: Address

    // MARK: Lifecycle

    init(owner: Address) {
        self.owner = owner
    }
}
