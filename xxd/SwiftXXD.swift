//
//  SwiftXXD.swift
//  xxd
//
//  Created by Matthew Axsom on 3/31/24.
//

import Foundation
import os.log
import ArgumentParser

@main
struct SwiftXXD : ParsableCommand {
    @Argument var name: String
    @Flag var log: Bool = false
    
    func run() throws {
        
        print("Hello World to \(name)!")
        if (log) {
            MyLogger.log.debug("Hello World")
        }
    }
}

struct MyLogger {
    static let log = Logger(subsystem: "com.gruecorner.swift-xxd", category: "swift-xxd")
}
