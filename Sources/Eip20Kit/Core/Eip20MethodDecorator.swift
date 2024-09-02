//
//  Eip20MethodDecorator.swift
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import EvmKit

// MARK: - Eip20MethodDecorator

class Eip20MethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: ContractMethodFactories

    // MARK: Lifecycle

    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension Eip20MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
