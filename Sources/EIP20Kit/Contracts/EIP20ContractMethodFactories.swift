//
//  EIP20ContractMethodFactories.swift
//  EIP20Kit
//
//  Created by Sun on 2024/9/2.
//

import Foundation

import EVMKit

class EIP20ContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = EIP20ContractMethodFactories()

    // MARK: Lifecycle

    override init() {
        super.init()
        register(factories: [TransferMethodFactory(), ApproveMethodFactory()])
    }
}
