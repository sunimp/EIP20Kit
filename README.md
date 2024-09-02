# EIP20Kit.Swift

`EIP20Kit.Swift` is an extension to `EVMKit.Swift` that implements `EIP20` token standard. 

## Features

- Synchronization of EIP20 token balance and transactions
- Allowance management
- Reactive API for wallet

## Usage

### Initialization

```swift
import EVMKit
import EIP20Kit
import HdWalletKit

let contractAddress = try EVMKit.Address(hex: "0x..token..contract..address..")

let evmKit = try Kit.instance(
	address: try EVMKit.Address(hex: "0x..user..address.."),
	chain: .ethereum,
	rpcSource: .ethereumInfuraWebsocket(projectId: "...", projectSecret: "..."),
	transactionSource: .ethereumEtherscan(apiKey: "..."),
	walletID: "unique_wallet_id",
	minLogLevel: .error
)

let eip20Kit = try EIP20Kit.Kit.instance(
	evmKit: evmKit, 
	contractAddress: contractAddress
)

// Decorators are needed to detect transactions as `EIP20` transfer/approve transactions
EIP20Kit.Kit.addDecorators(to: evmKit)

// EIP20 transactions syncer is needed to pull EIP20 transfer transactions from Etherscan
EIP20Kit.Kit.addTransactionSyncer(to: evmKit)
```


### Get token balance

```swift
guard let balance = eip20Kit.balance else {
	return
}

print("Balance: \(balance.description)")

```

### Send `EIP20` Transaction

```swift
// Get Signer object
let seed = Mnemonic.seed(mnemonic: ["mnemonic", "words", ...])!
let signer = try Signer.instance(seed: seed, chain: .ethereum)

let to = try EVMKit.Address(hex: "0x..recipient..adress..here")
let amount = BigUInt("100000000000000000")
let gasPrice = GasPrice.legacy(gasPrice: 50_000_000_000)

// Construct TransactionData which calls a `Transfer` method of the EIP20 compatible smart contract
let transactionData = eip20Kit.transferTransactionData(to: to, value: amount)

// Estimate gas for the transaction
let estimateGasSingle = evmKit.estimateGas(transactionData: transactionData, gasPrice: gasPrice)

// Generate a raw transaction which is ready to be signed
let rawTransactionSingle = estimateGasSingle.flatMap { estimatedGasLimit in
    evmKit.rawTransaction(transactionData: transactionData, gasPrice: gasPrice, gasLimit: estimatedGasLimit)
}

let sendSingle = rawTransactionSingle.flatMap { rawTransaction in
    // Sign the transaction
    let signature = try signer.signature(rawTransaction: rawTransaction)
    
    // Send the transaction to RPC node
    return evmKit.sendSingle(rawTransaction: rawTransaction, signature: signature)
}


let disposeBag = DisposeBag()

// This step is needed for Rx reactive code to run
sendSingle
    .subscribe(
        onSuccess: { fullTransaction in
            // sendSingle returns FullTransaction object which contains transaction, and a transaction decoration
            // EIP20Kit.Swift kit creates a OutgoingDecoration decoration for transfer method transaction

            let transaction = fullTransaction.transaction
            print("Transaction sent: \(transaction.hash.ww.hexString)")

            guard let decoration = transaction.decoration as? OutgoingDecoration else {
                return
            }

            print("To: \(decoration.to.eip55)")
            print("Amount: \(decoration.value.description)")
        }, onError: { error in
            print("Send failed: \(error)")
        }
    )
    .disposed(by: disposeBag)
```

### Get transactions

```swift
evmKit.transactionsSingle(tagQueries: [TransactionTagQuery(protocol: .eip20, contractAddress: contractAddress)])
    .subscribe(
        onSuccess: { fullTransactions in
            for fullTransaction in fullTransactions {
                let transaction = fullTransaction.transaction
                print("Transaction hash: \(transaction.hash.ww.hexString)")

                switch fullTransaction.decoration {
                case let decoration as IncomingDecoration:
                    print("From: \(decoration.from.eip55)")
                    print("Amount: \(decoration.value.description)")

                case let decoration as OutgoingDecoration:
                    print("To: \(decoration.to.eip55)")
                    print("Amount: \(decoration.value.description)")

                default: ()
                }
            }
        }, onError: { error in
            print("Send failed: \(error)")
        }
    )
    .disposed(by: disposeBag)
```

## Requirements

* Xcode 15.4+
* Swift 5.10+
* iOS 14.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/sunimp/EIP20Kit.Swift.git", .upToNextMajor(from: "2.2.0"))
]
```

## License

The `EIP20Kit.Swift` toolkit is open source and available under the terms of the [MIT License](https://github.com/sunimp/EIP20Kit.Swift/blob/main/LICENSE).

