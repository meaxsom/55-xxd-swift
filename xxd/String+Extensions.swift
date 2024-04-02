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
