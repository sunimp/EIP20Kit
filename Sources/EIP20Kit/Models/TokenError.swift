//
//  TokenError.swift
//
//  Created by Sun on 2024/9/2.
//

import Foundation

public enum TokenError: Error {
    case invalidHex
    case notRegistered
    case alreadyRegistered
}
