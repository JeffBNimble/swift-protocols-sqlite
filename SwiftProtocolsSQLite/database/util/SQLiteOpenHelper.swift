//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import SwiftProtocolsCore

/**

**SQLiteOpenHelper** defines a process for opening and upgrading/downgrading a database schema.
The SQLOpenDBHelper is conceptually similar to its Android counterpart, which you can read
about here: http://developer.android.com/reference/android/database/sqlite/SQLiteOpenHelper.html

The lifecycle of operations for the helper are as follows:
# onConfigure: Called when the database has been configured
# onCreate: Called if and when the database is initially created
# onUpgrade/Downgrade: Called if and when there is a mismatch between the current database version and the version passed
    on the initializer
# onOpen: Called when the database has been opened

*/

public protocol SQLiteOpenHelper {
    /// databaseName: The relative path including the name of the database (i.e. databases/datadragon.sqlite3)
    var databaseName: String? { get }

    /// version: The version of the database (used for upgrading/downgrading the database schema)
    var version: Int { get }

    /// init(databaseName:String, version:Int): The initializer for the SQLiteOpenHelper
    /// - Parameter sqliteDatabaseFactory: A Factory used to create new SQLiteDatabase instances
    /// - Parameter databaseName: A relative path and database file name (i.e. databases/datadragon.sqlite3)
    /// - Parameter version: The database schema version to use
    init(databaseFactory: Factory, databaseName: String?, version: Int)

    /// close: Close the database
    /// - Throws: A SQLiteDatabaseError if the database cannot be closed
    func close() throws

    /// getDatabase(): Returns a SQLiteDatabase instance which may or may not be open, created, upgraded/downgraded.
    ///     It is the responsibility of the app/module to open, create, upgrade/downgrade appropriately
    /// - Returns: A SQLiteDatabase
    func getDatabase() -> SQLiteDatabase

    /// onConfigure(database:SQLiteDatabase): Called when the specified database has been configured
    /// - Parameter database: The SQLiteDatabase that has been configured
    func onConfigure(database: SQLiteDatabase) throws

    /// onCreate(database:SQLiteDatabase): Called if and when the specified database has been created for the first time
    /// - Parameter database: The SQLiteDatabase that has been created
    func onCreate(database: SQLiteDatabase) throws

    /// onDowngrade(database:SQLiteDatabase, fromOldVersion:Int, toNewVersion:Int): Called if and when the current database version is greater
    ///     than the version passed on the initializer.
    /// - Parameter database: The SQLiteDatabase whose version is being downgraded
    /// - Parameter fromOldVersion: The current version of the database schema
    /// - Parameter toNewVersion: The new version of the database schema
    func onDowngrade(database: SQLiteDatabase, fromOldVersion oldVersion:Int, toNewVersion newVersion:Int) throws

    /// onOpen(database:SQLiteDatabase): Called when the specified database has been opened
    /// - Parameter: datbase: The SQLiteDatabase that has been opened
    func onOpen(database: SQLiteDatabase) throws

    /// onUpgrade(database:SQLiteDatabase, fromOldVersion:Int, toNewVersion:Int): Called if and when the current database version is less
    ///     than the version passed on the initializer.
    /// - Parameter database: The SQLiteDatabase whose version is being upgraded
    /// - Parameter fromOldVersion: The current version of the database schema
    /// - Parameter toNewVersion: The new version of the database schema
    func onUpgrade(database: SQLiteDatabase, fromOldVersion oldVersion: Int, toNewVersion newVersion: Int) throws
    
    /// prepare(): Prepare a database for use by opening, creating (the schema), upgrading/downgrading
    /// Throws: A SQLiteDatabaseError if the database cannot be opened, created, upgraded or downgraded
    func prepare() throws
}

/**
 A base class implementation of the SQLiteOpenHelper protocol
 */
public class BaseSQLiteOpenHelper : SQLiteOpenHelper {
    public var databaseName : String?
    public var version : Int

    private var database : SQLiteDatabase?
    private var databaseFactory : Factory
    private let databaseLockQueue = dispatch_queue_create("io.nimblenoggin.database_create_lock_queue", nil)

    public required init(databaseFactory: Factory, databaseName: String?, version: Int) {
        self.databaseName = databaseName;
        self.version = version;
        self.databaseFactory = databaseFactory
    }

    public func close() throws {
        guard let db = self.database else {
            return
        }

        try db.close()
    }

    public func getDatabase() -> SQLiteDatabase {
        guard let db = self.database else {
            self.database = self.databaseFactory.create(self.asAbsolutePath(self.databaseName)) as SQLiteDatabase
            return self.database!
        }
        
        return db
    }
    
    public func onConfigure(database: SQLiteDatabase) throws {
    }

    public func onCreate(database: SQLiteDatabase) throws {
    }

    public func onDowngrade(database: SQLiteDatabase, fromOldVersion oldVersion: Int, toNewVersion newVersion: Int) throws {
    }

    public func onOpen(database: SQLiteDatabase) {
    }

    public func onUpgrade(database: SQLiteDatabase, fromOldVersion oldVersion: Int, toNewVersion newVersion: Int) throws {
    }
    
    public func prepare() throws {
        let db = self.getDatabase()
        
        guard !db.isOpen else {
            return
        }
        
        // dispatch the creation of the database and open/upgrade/downgrade to a lock queue to prevent
        // multiple threads from concurrently performing this action
        dispatch_sync(self.databaseLockQueue, {
            // Check once again for database already open just in case the caller was blocked on a previous prepare
            guard !db.isOpen else {
                return
            }
            
            do {
                try db.open()
                try db.startTransaction()
                    
                DDLogVerbose("Configuring SQLite database...")
                try self.onConfigure(db)
                    
                // If the database version is 0, we just created it
                let currentVersion:Int = try self.getCurrentDatabaseVersion()
                if currentVersion == 0 {
                    DDLogVerbose("Creating SQLite database...")
                    try self.onCreate(db)
                }
                    
                // Upgrade or downgrade if necessary
                if currentVersion > 0 {
                    if currentVersion < self.version {
                        DDLogVerbose("Upgrading SQLite database from V\(currentVersion) to V\(self.version)...")
                        try self.onUpgrade(db, fromOldVersion:currentVersion, toNewVersion:self.version)
                    } else if currentVersion > self.version {
                        DDLogVerbose("Downgrading SQLite database from V\(currentVersion) to V\(self.version)...")
                        try self.onDowngrade(db, fromOldVersion:currentVersion, toNewVersion:self.version)
                    }
                }
                    
                // If the current and new database versions are different, mark the database version with the new version
                if currentVersion != self.version {
                    try self.setNewDatabaseVersion(self.version)
                }
                    
                DDLogVerbose("Opening SQLite database...")
                self.onOpen(db)
                    
                try db.commit()
            } catch {
                DDLogError("An error occurred attempting to prepare the database")
            }
        })
        
    }

    private func asAbsolutePath(relativePath:String?) -> String? {
        // If relativePath is nil, just return nil for an in-memory database
        guard let path = relativePath else {
            DDLogVerbose("Using SQLite in-memory database")
            return nil
        }
        
        // If path is an empty string, return an empty string for a temporary database
        guard path.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
            DDLogVerbose("Using SQLite temporary database")
            return path
        }

        // Otherwise, return an absolute path in the apps documents folder
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0];
        let fullPath = (documentsPath as NSString).stringByAppendingPathComponent(path);
        DDLogVerbose("Using SQLite database at '\(fullPath)'")
        return fullPath
    }

    private func getCurrentDatabaseVersion() throws -> Int {
        let db = self.database!
        let cursor = try db.executeQuery("PRAGMA user_version")
        var version = 0;

        if cursor.next() {
            version = cursor.intFor("user_version")
        }

        cursor.close()

        return version;
    }

    private func setNewDatabaseVersion(version:Int) throws {
        let db = self.database!
        try db.executeUpdate("PRAGMA user_version = \(version)")
    }

}