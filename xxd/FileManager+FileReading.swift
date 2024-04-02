//
//  FileManager-FileReading.swift
//  xxd
//
//  Created by Matthew Axsom on 4/1/24.
//

import Foundation

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
}
