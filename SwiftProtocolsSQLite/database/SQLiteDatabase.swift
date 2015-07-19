//
// Created by Jeffrey Roberts on 7/12/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

/**
 * SQLiteDatabase is a protocol that desribes the interface to a sqlite3 database. It provides an
 * interface for opening and closing, starting, rolling back or committing transactions and
 * executing SQL statements.
 */
protocol SQLiteDatabase {
    /// changes: The number of rows inserted/updated/deleted from the last successful SQL statement
    var changes:Int {get}

    /// isOpen: A boolean indicating whether the database is currently open
    var isOpen:Bool {get}

    /// lastInsertedRowId: The unique id of the row last inserted
    var lastInsertedRowId:Int {get}

    /// path: THe absolute path to the sqlite3 database file
    var path:String? {get}

    /// init: Initializer for a SQLiteDatabase implementation
    /// Parameter path: The absolute path to the sqlite3 database file.
    /// - non-nil path: Identifies the actual path to the sqlite3 database file including the filename
    /// - nil: Identifies an in-memory database
    init(path:String?)

    /// open: Open the database
    /// Returns: A boolean indicating whether or not the database was successfully opened
    /// Throws: A SQLiteDatabaseError if the database could not be opened
    func open() throws -> Bool

    /// close: Close the database
    /// Returns: A boolean indicating whether or not the database was successfully closed
    /// THrows: A SQLiteDatabaseError if the database could not be opened
    func close() throws -> Bool

    /// startTransaction: Starts a database transaction
    /// Returns: A boolean indicating whether or not a database transaction was started
    /// Throws: A SQLiteDatabaseError if the transaction was not started
    func startTransaction() throws -> Bool

    /// commit: Commits an existing database transaction
    /// Returns: A boolean indicating whether or not the commit was successful
    /// Thows: A SQLiteDatbaseError if the transaction was not committed
    func commit() throws -> Bool

    /// rollback: Rolls back an existing database transaction
    /// Returns: A boolean indicting whether or not the transaction as successfully rolled back
    /// Throws: A SQLiterDatabaseError if the transation was not rolled bak
    func rollback() throws -> Bool

    /// executeUpdate: Executes a SQL statement that updates the database in some way
    /// Parameter sqlString: THe SQL string to execute
    /// Returns: The number of rows inserted/updated/deleted
    /// THrows: A SQLiteDatbaseError if the statement fails
    func executeUpdate(sqlString: String) throws -> Int

    /// executeUpdate: Executes a SQL statement that updates the database in some way
    /// Parameter sqlString: THe SQL string to execute
    /// Parameter parameters: An Array of parameters that are bound to parameter markers in the SQL
    /// Returns: The number of rows inserted/updated/deleted
    /// THrows: A SQLiteDatbaseError if the statement fails
    func executeUpdate(sqlString: String, parameters:[AnyObject?]?) throws -> Int

    /// executeUpdate: Executes a SQL statement that updates the database in some way
    /// Parameter sqlString: THe SQL string to execute
    /// Parameter parameters: A Dictionary of parameters that are bound to bind variables in the SQL
    /// Returns: The number of rows inserted/updated/deleted
    /// THrows: A SQLiteDatbaseError if the statement fails
    func executeUpdate(sqlString: String, parameters:[String:AnyObject?]?) throws -> Int

    /// executeQuery: Executes a SQL query statement that returns zero or more rows
    /// Parameter sqlString: THe SQL string to execute
    /// Returns: A cursor containing the query results
    /// THrows: A SQLiteDatbaseError if the statement fails
    func executeQuery(sqlString: String) throws -> Cursor

    /// executeQuery: Executes a SQL query statement that returns zero or more rows
    /// Parameter sqlString: THe SQL string to execute
    /// Parameter parameters: An Array of parameters that are bound to parameter markers in the SQL
    /// Returns: The number of rows inserted/updated/deleted
    /// THrows: A SQLiteDatbaseError if the statement fails
    func executeQuery(sqlString: String, parameters:[AnyObject?]?) throws -> Cursor

    /// executeQuery: Executes a SQL query statement that returns zero or more rows
    /// Parameter sqlString: THe SQL string to execute
    /// Parameter parameters: A Dictionary of parameters that are bound to bind variables in the SQL
    /// Returns: The number of rows inserted/updated/deleted
    /// THrows: A SQLiteDatbaseError if the statement fails
    func executeQuery(sqlString: String, parameters:[String:AnyObject?]?) throws -> Cursor
}
