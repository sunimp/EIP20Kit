//
//  Eip20MethodDecorator.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class Eip20MethodDecorator {
    private let contractMethodFactories: ContractMethodFactories

    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

extension Eip20MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
