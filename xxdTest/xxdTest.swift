//
//  xxdTest.swift
//  xxdTest
//
//  Created by Matthew Axsom on 3/31/24.
//

import XCTest

final class xxdTest: XCTestCase {
    
    private static let kData = "7801edd0b10900201003407112cb5fc3"
    private static let kAsciiData = "x...... ..@q.._."
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChunked() throws {
        let theBytes = xxdTest.kData.hexaBytes
        
        var theGroups = theBytes.chunked(into: 2)
        XCTAssertEqual(theGroups.count, 8)
        
        theGroups = theBytes.chunked(into: 4)
        XCTAssertEqual(theGroups.count, 4)
        
        theGroups = theBytes.chunked(into: 1)
        XCTAssertEqual(theGroups.count, 16)
        
        theGroups = theBytes.chunked(into: 3)
        XCTAssertEqual(theGroups.count, 6)
    }
    
    func testToHexString() throws {
        let theBytes = xxdTest.kData.hexaBytes
        let theGroups = theBytes.chunked(into: 2)

        XCTAssertEqual(theGroups.count, 8)
        
        XCTAssertEqual(theGroups[0].toHexString(), "7801")
        XCTAssertEqual(theGroups[1].toHexString(), "edd0")
        XCTAssertEqual(theGroups[2].toHexString(), "b109")
        XCTAssertEqual(theGroups[7].toHexString(), "5fc3")
    }
    
    func testStringFromBytes() throws {
        let theBytes = xxdTest.kData.hexaBytes
        XCTAssertEqual(String(theBytes), xxdTest.kAsciiData)
    }
    
    func testLittleEndian() throws {
        let theBytes = xxdTest.kData.hexaBytes
        var theGroups = theBytes.chunked(into: 2)
        
        XCTAssertEqual(theGroups.count, 8)
        XCTAssertEqual(theGroups[0].toLittleEndian().toHexString(), "0178")
        XCTAssertEqual(theGroups[1].toLittleEndian().toHexString(), "d0ed")
        XCTAssertEqual(theGroups[2].toLittleEndian().toHexString(), "09b1")
        XCTAssertEqual(theGroups[7].toLittleEndian().toHexString(), "c35f")

        theGroups = theBytes.chunked(into: 4)
        XCTAssertEqual(theGroups[0].toLittleEndian().toHexString(), "d0ed0178")
        XCTAssertEqual(theGroups[1].toLittleEndian().toHexString(), "200009b1")
    }
}
