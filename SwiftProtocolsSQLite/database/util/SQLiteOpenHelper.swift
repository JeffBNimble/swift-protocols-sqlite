//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

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
    var databaseName: String { get }

    /// version: The version of the database (used for upgrading/downgrading the database schema)
    var version: Int { get }

    /// init(databaseName:String, version:Int): The initializer for the SQLiteOpenHelper
    /// - Parameter sqliteDatabaseFactory: A SQLiteDatabaseFactory used to create new SQLiteDatabase instances
    /// - Parameter databaseName: A relative path and database file name (i.e. databases/datadragon.sqlite3)
    /// - Parameter version: The database schema version to use
    init(databaseFactory: SQLiteDatabaseFactory, databaseName: String, version: Int)

    /// close: Close the database
    /// - Throws: A SQLiteDatabaseError if the database cannot be closed
    func close() throws

    /// getDatabase(): Returns a SQLiteDatabase instance ready to execute SQL commands
    /// - Returns: A configured, created, upgraded/downgraded and open SQLiteDatabase
    func getDatabase() throws -> SQLiteDatabase

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
    func onDowngrade(database: SQLiteDatabase, fromOldVersion:Int, toNewVersion:Int) throws

    /// onOpen(database:SQLiteDatabase): Called when the specified database has been opened
    /// - Parameter: datbase: The SQLiteDatabase that has been opened
    func onOpen(database: SQLiteDatabase) throws

    /// onUpgrade(database:SQLiteDatabase, fromOldVersion:Int, toNewVersion:Int): Called if and when the current database version is less
    ///     than the version passed on the initializer.
    /// - Parameter database: The SQLiteDatabase whose version is being upgraded
    /// - Parameter fromOldVersion: The current version of the database schema
    /// - Parameter toNewVersion: The new version of the database schema
    func onUpgrade(database: SQLiteDatabase, fromOldVersion: Int, toNewVersion: Int) throws
}

/**
 A base class implementation of the SQLiteOpenHelper protocol
 */
public class BaseSQLiteOpenHelper : SQLiteOpenHelper {
    public var databaseName: String
    public var version: Int

    private var database:SQLiteDatabase?
    private var databaseFactory:SQLiteDatabaseFactory

    public required init(databaseFactory: SQLiteDatabaseFactory, databaseName: String, version: Int) {
        self.databaseName = databaseName;
        self.version = version;
        self.databaseFactory = databaseFactory
    }

    public func close() throws {
        guard let db = self.database else {
            return
        }

        try(db.close())
    }

    public func getDatabase() throws -> SQLiteDatabase {
        guard let database = self.database else {
            self.database = self.databaseFactory.createWithPath(self.asAbsolutePath(self.databaseName))
            
            let db = self.database!

            try(db.open())
            try(db.startTransaction())

            self.onConfigure(db)

            // If the database version is 0, we just created it
            let currentVersion:Int = try(self.getCurrentDatabaseVersion())
            if currentVersion == 0 {
                self.onCreate(db)
            }

            // Upgrade or downgrade if necessary
            if currentVersion > 0 {
                if currentVersion < self.version {
                    self.onUpgrade(db, fromOldVersion:currentVersion, toNewVersion:self.version)
                } else if currentVersion > self.version {
                    self.onDowngrade(db, fromOldVersion:currentVersion, toNewVersion:self.version)
                }
            }

            // If the current and new database versions are different, mark the database version with the new version
            if currentVersion != self.version {
                try(self.setNewDatabaseVersion(self.version))
            }

            self.onOpen(db)

            try(db.commit())

            return db
        }

        return database
    }

    public func onConfigure(database: SQLiteDatabase) {
    }

    public func onCreate(database: SQLiteDatabase) {
    }

    public func onDowngrade(database: SQLiteDatabase, fromOldVersion: Int, toNewVersion: Int) {
    }

    public func onOpen(database: SQLiteDatabase) {
    }

    public func onUpgrade(database: SQLiteDatabase, fromOldVersion: Int, toNewVersion: Int) {
    }

    private func asAbsolutePath(relativePath:String?) -> String? {
        guard let path = relativePath else {
            return nil
        }

        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0];
        return documentsPath.stringByAppendingPathComponent(path);
    }

    private func getCurrentDatabaseVersion() throws -> Int {
        let db = self.database!
        let cursor = try(db.executeQuery("PRAGMA user_version"))
        var version = 0;

        if cursor.next() {
            version = cursor.intFor("user_version")
        }

        cursor.close()

        return version;
    }

    private func setNewDatabaseVersion(version:Int) throws {
        let db = self.database!
        try(db.executeUpdate("PRAGMA user_version = \(version)"))
    }

}