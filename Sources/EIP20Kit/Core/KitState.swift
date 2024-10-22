//
//  KitState.swift
//  EIP20Kit
//
//  Created by Sun on 2019/4/26.
//

import Combine
import Foundation

import BigInt
import EVMKit

class KitState {
    // MARK: Properties

    let syncStateSubject = PassthroughSubject<SyncState, Never>()
    let balanceSubject = PassthroughSubject<BigUInt, Never>()

    // MARK: Computed Properties

    var syncState: SyncState = .syncing(progress: nil) {
        didSet {
            if syncState != oldValue {
                syncStateSubject.send(syncState)
            }
        }
    }

    var balance: BigUInt? {
        didSet {
            if let balance, balance != oldValue {
                balanceSubject.send(balance)
            }
        }
    }
}
