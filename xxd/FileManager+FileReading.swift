//
//  FileManager-FileReading.swift
//  xxd
//
//  Created by Matthew Axsom on 4/1/24.
//

import Foundation

let kDefaultBufferSize = 4096
let kNewLineByte : UInt8 = UInt8("\n".unicodeScalars.first!.value)

extension FileHandle {
    func readUInt8s(ofSize inSize: Int) -> [UInt8]? {
        guard let data = try? read(upToCount: inSize) else {
            return nil
        }
        // Ensure the data is of the correct size
        guard (data.count != 0) && (data.count <= inSize) else {
            return nil
        }
        
        let result = [UInt8](data)
        return result
    }
    
    // just a hacky way to read line.. not meant to be extremenly robust
    // resets the file position after finding the end-of-line in the buffer
    func readLine() -> String? {
        guard let theStartOffset = try? offset() else {
            return nil
        }
        
        guard let data = try? read(upToCount: kDefaultBufferSize) else {
            return nil
        }
        
        // Ensure the data is of the correct size
        guard (data.count != 0) && (data.count <= kDefaultBufferSize) else {
            return nil
        }
        
        var result: String = ""
        
        if let firstIndex=data.firstIndex(where: { $0 == kNewLineByte}) {
            let range = 0..<firstIndex
            result=String(decoding: data.subdata(in: range), as:UTF8.self)
            guard ((try? seek(toOffset: theStartOffset + UInt64(firstIndex)+1)) != nil) else {
                return result
            }
        }
        
        return result
    }
}
