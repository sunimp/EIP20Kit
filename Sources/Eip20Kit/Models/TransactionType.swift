//
//  TransactionType.swift
//
//  Created by Sun on 2021/1/8.
//

import Foundation

import GRDB

public enum TransactionType: String, DatabaseValueConvertible {
    case transfer
    case approve

    // MARK: Computed Properties

    public var databaseValue: DatabaseValue {
        rawValue.databaseValue
    }

    // MARK: Static Functions

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> TransactionType? {
        if case let DatabaseValue.Storage.string(value) = dbValue.storage {
            return TransactionType(rawValue: value)
        }

        return nil
    }
}
