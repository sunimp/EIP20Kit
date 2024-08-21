//
//  Eip20ContractMethodFactories.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class Eip20ContractMethodFactories: ContractMethodFactories {
    static let shared = Eip20ContractMethodFactories()

    override init() {
        super.init()
        register(factories: [TransferMethodFactory(), ApproveMethodFactory()])
    }
}
