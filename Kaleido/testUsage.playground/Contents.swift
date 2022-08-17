import UIKit
import Foundation
import CommonCrypto
func sha256(data : Data) -> Data {
    var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
    }
    return Data(hash)
}
let dateNow = String(Int(Date().timeIntervalSince1970))
let dataNowDate = dateNow.data(using: .utf8)!
let sha256Result = sha256(data: dataNowDate)
let resultStr = sha256Result.map { String(format: "%02hhx", $0) }.joined()



