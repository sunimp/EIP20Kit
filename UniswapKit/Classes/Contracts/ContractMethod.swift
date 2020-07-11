import OpenSslKit
import BigInt

struct ContractMethod {
    private let name: String
    private let arguments: [Argument]

    init(name: String, arguments: [Argument] = []) {
        self.name = name
        self.arguments = arguments
    }

    var encodedData: Data {
        var data = signature
        var arraysData = Data()

        for argument in arguments {
            switch argument {
            case .uint256(let value):
                data += pad(data: value.serialize())
            case .address(let value):
                data += pad(data: value)
            case .addresses(let array):
                data += pad(data: BigUInt(arguments.count * 32 + arraysData.count).serialize())
                arraysData += encode(array: array)
            }
        }

        return data + arraysData
    }

    private var signature: Data {
        let argumentTypes = arguments.map { $0.type }.joined(separator: ",")
        let structure = "\(name)(\(argumentTypes))"
        return OpenSslKit.Kit.sha3(structure.data(using: .ascii)!)[0...3]
    }

    private func encode(array: [Data]) -> Data {
        var data = pad(data: BigUInt(array.count).serialize())

        for item in array {
            data += pad(data: item)
        }

        return data
    }

    private func pad(data: Data) -> Data {
        Data(repeating: 0, count: (max(0, 32 - data.count))) + data
    }

}

extension ContractMethod {

    enum Argument {
        case uint256(BigUInt)
        case address(Data)
        case addresses([Data])

        var type: String {
            switch self {
            case .uint256: return "uint256"
            case .address: return "address"
            case .addresses: return "address[]"
            }
        }
    }

}
