//
//  TransactionType.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

public enum TransactionType: String, DatabaseValueConvertible {
    
    case transfer
    case approve

    public var databaseValue: DatabaseValue {
        rawValue.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> TransactionType? {
        if case DatabaseValue.Storage.string(let value) = dbValue.storage {
            return TransactionType(rawValue: value)
        }

        return nil
    }
}
