//
//  TokenError.swift
//  Eip20Kit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public enum TokenError: Error {
    case invalidHex
    case notRegistered
    case alreadyRegistered
}
