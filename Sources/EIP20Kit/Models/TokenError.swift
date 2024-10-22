//
//  TokenError.swift
//  EIP20Kit
//
//  Created by Sun on 2019/11/26.
//

import Foundation

public enum TokenError: Error {
    case invalidHex
    case notRegistered
    case alreadyRegistered
}
