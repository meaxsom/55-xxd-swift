//
//  Array-Extensions.swift
//  xxd
//
//  Created by Matthew Axsom on 4/2/24.
//

import Foundation

extension Array where Element == UInt8 {
    // takes an array of UInt8 elements, converts each element to hex and then concats all of them together into a string
   func toHexString() -> String {
        return self.map { String(format: "%02x", $0) }.joined()
    }
    
    // convert a array of UInt8s to little endian format
    func toLittleEndian() -> [UInt8] {
        var result = [UInt8](repeating: 0, count: self.count)
        for (index, byte) in self.enumerated() {
            result[self.count - 1 - index] = byte
        }
        return result
    }
}

// returns an array of arrays grouped into arrays of size
// if it's not evenly divisible the last group will have less elements than the others
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
