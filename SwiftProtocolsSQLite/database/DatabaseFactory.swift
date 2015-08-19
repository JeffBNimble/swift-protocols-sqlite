//
//  DatabaseFactory.swift
//  SwiftProtocolsSQLite
//
//  Created by Jeff Roberts on 8/17/15.
//  Copyright © 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation
import SwiftProtocolsCore

@objc
public class DatabaseFactory : NSObject, Factory {
    public required override init() {
        super.init()
    }
    
    public func create(with: String?) throws -> SQLiteDatabase {
        throw CoreError.SubclassShouldImplementError
    }
}