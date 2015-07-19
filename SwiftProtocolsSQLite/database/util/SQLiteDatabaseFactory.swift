//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

/**
**SQLiteDatabaseFactory** is a definition for a component that creates SQLitedatabase instances
*/
public protocol SQLiteDatabaseFactory {
    /// createWithPath:Creates a new SQLiteDatabase instance with the specified absolute path
    /// - Parameter absolutePath: The absolute path (or nil for an in-memory database)
    /// - Returns: A new instance of a class that conforms to the SQLiteDatabase protocol
    func createWithPath(absolutePath:String?) -> SQLiteDatabase
}
