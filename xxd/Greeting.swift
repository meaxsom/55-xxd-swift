//
//  Greeting.swift
//  xxd
//
//  Created by Matthew Axsom on 3/31/24.
//

import Foundation

struct Greeting {
    private var _name: String = ""
    
    public var name : String {
        set {_name = newValue}
        get {return _name}
    }
}
