//
//  EIP20MethodDecorator.swift
//  EIP20Kit
//
//  Created by Sun on 2024/9/2.
//

import Foundation

import EVMKit

// MARK: - EIP20MethodDecorator

class EIP20MethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: ContractMethodFactories

    // MARK: Lifecycle

    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension EIP20MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
