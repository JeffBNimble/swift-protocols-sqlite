//
// Created by Jeffrey Roberts on 2/8/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

import SwiftProtocolsSQLite

class MockSQLiteDatabase : SQLiteDatabase {
    var namedParameters : [String : AnyObject]?
    var parameterArray : [AnyObject]?
    var sqlString : String?

    var changes: Int {
        return 0
    }
    var isOpen: Bool {
        return false
    }
    var lastInsertedRowId: Int {
        return 0
    }
    var path: String? {
        return nil
    }

    required init(path: String?) {
    }

    func open() throws -> Bool {
        return false
    }

    func close() throws -> Bool {
        return false
    }

    func startTransaction() throws -> Bool {
        return false
    }

    func commit() throws -> Bool {
        return false
    }

    func rollback() throws -> Bool {
        return false
    }

    func executeUpdate(sqlString: String) throws -> Int {
        self.sqlString = sqlString
        return 0
    }

    func executeUpdate(sqlString: String, parameters: [AnyObject]?) throws -> Int {
        self.sqlString = sqlString
        self.parameterArray = parameters
        return 0
    }

    func executeUpdate(sqlString: String, parameters: [String:AnyObject]?) throws -> Int {
        self.sqlString = sqlString
        self.namedParameters = parameters
        return 0
    }

    func executeQuery(sqlString: String) throws -> Cursor {
        self.sqlString = sqlString
        return MockCursor()
    }

    func executeQuery(sqlString: String, parameters: [AnyObject]?) throws -> Cursor {
        self.sqlString = sqlString
        self.parameterArray = parameters
        return MockCursor()
    }

    func executeQuery(sqlString: String, parameters: [String:AnyObject]?) throws -> Cursor {
        self.sqlString = sqlString
        self.namedParameters = parameters
        return MockCursor()
    }

}
