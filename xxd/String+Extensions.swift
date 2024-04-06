//
//  String-Extensions.swift
//  xxd
//
//  Created by Matthew Axsom on 4/2/24.
//

import Foundation

// returns a string version - printable characters only - of an array of bytes
extension String {
    init(_ bytes: [UInt8]) {
        self.init(
            bytes.reduce("", 
                {$0 + String(($1 >= 32 && $1 <= 126) ? UnicodeScalar($1) : ".")}
            ))
    }
}

// converts a string of hex characters into an array of UInt8s
extension StringProtocol {
    var hexaBytes: [UInt8] {
        var startIndex = self.startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}

