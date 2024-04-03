//
//  OctetCounter.swift
//  xxd
//
//  Created by Matthew Axsom on 4/2/24.
//

import Foundation

// keeps track of the number of Octets read and calculates how many can be read the next time based on a max
// if no max it's alwasy the default count

struct OctetCounter {
    public static let kNoLength = -1
    public static let kDefaultOctetSize = 16
        
    private var maxOctetCount : Int = OctetCounter.kNoLength
    private var octetCount : Int = 0
    private var _octextSize : Int = OctetCounter.kDefaultOctetSize
    
    public init(max inMaxOctets: Int) {
        self.maxOctetCount = inMaxOctets
    }

    public init(max inMaxOctets: Int, size inOctetSize: Int) {
        self.maxOctetCount = inMaxOctets
        self._octextSize = inOctetSize
    }

    public var octextSize: Int {
        return self._octextSize
    }
    
    public mutating func incrementOctetsRead(by inAmount: Int) {
        self.octetCount += inAmount;
    }
    
    public func octetsToRead() -> Int {
        var result = self._octextSize
        if (maxOctetCount != OctetCounter.kNoLength) {
            if (octetCount < maxOctetCount) {
                result = maxOctetCount - octetCount > result ? result : maxOctetCount - octetCount
            } else {
                result = 0
            }
        }
        return result
    }
}
