//
//  TokenBalance.swift
//
//  Created by Sun on 2019/4/18.
//

import Foundation

import BigInt
import GRDB

class TokenBalance: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case primaryKey
        case value
    }

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "token_balances"
    }

    // MARK: Properties

    let primaryKey = "primaryKey"
    let value: BigUInt?

    // MARK: Lifecycle

    init(value: BigUInt?) {
        self.value = value

        super.init()
    }

    required init(row: Row) throws {
        value = row[Columns.value]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.primaryKey] = primaryKey
        container[Columns.value] = value
    }
}
