//
//  Eip20ContractMethodFactories.swift
//
//  Created by Sun on 2021/3/4.
//

import Foundation

import EvmKit

class Eip20ContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = Eip20ContractMethodFactories()

    // MARK: Lifecycle

    override init() {
        super.init()
        register(factories: [TransferMethodFactory(), ApproveMethodFactory()])
    }
}
