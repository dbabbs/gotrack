//
//  Utilities.swift
//  gotrack
//
//  Created by Keegs on 12/6/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import Foundation

class Log {

    static func debug(_ myself: AnyObject, _ info: String) {
        print("> Debug: \(myself) :: \(info)")
    }

    static func error(in object: AnyObject, because reason: String) {
        print(">> Error in \(object): \(reason)")
    }

    static func info(_ info: String) {
        print("> Info: \(info)")
    }

    static func info(in object: AnyObject, _ info: String) {
        print("> Info: \(object) :: \(info)")
    }
}
