//
//  TokenBalance.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import GRDB

class TokenBalance: Record {
    let primaryKey = "primaryKey"
    let value: BigUInt?

    init(value: BigUInt?) {
        self.value = value

        super.init()
    }

    override class var databaseTableName: String {
        "token_balances"
    }

    enum Columns: String, ColumnExpression {
        case primaryKey
        case value
    }

    required init(row: Row) throws {
        value = row[Columns.value]

        try super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.primaryKey] = primaryKey
        container[Columns.value] = value
    }
}
