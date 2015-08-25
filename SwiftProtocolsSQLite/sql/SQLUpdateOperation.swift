//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift

/**

**SQLUpdateOperation** represents a SQL INSERT, UPDATE or DELETE operation that either inserts, updates
or deletes in a single database table.

*/
@objc
public class SQLUpdateOperation: SQLiteOperation {
    /// An optional map of values that will be inserted/updated where the key is the column name and
    /// the value is the column value
    public var contentValues:[String: AnyObject]?

    public override init(database: SQLiteDatabase, statementBuilder: SQLStatementBuilder) {
        super.init(database: database, statementBuilder: statementBuilder)
    }

    /// executeDelete(): Deletes zero or more rows from a database table
    /// - Returns: The count of rows deleted after execution of the statement
    public func executeDelete() throws -> Int {
        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }
        
        let hasNamedParameters = self.namedSelectionArgs != nil
        let statement = self.statementBuilder.buildDeleteStatement(table, selection: self.selection)
        if hasNamedParameters {
            DDLogVerbose("Executing \(statement) with named parameters: \(self.namedSelectionArgs)")
            return try self.database.executeUpdate(statement, parameters:self.namedSelectionArgs)
        } else {
            DDLogVerbose("Executing \(statement) with parameters: \(self.selectionArgs)")
            return try self.database.executeUpdate(statement, parameters:self.selectionArgs)
        }
    }

    /// executeInsert(): Inserts a row into a database table
    /// - Returns: The count of rows inserted after execution of the statement, should be 1
    public func executeInsert() throws -> Int {
        guard let values = self.contentValues else {
            throw SQLError.MissingContentValues
        }

        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        let statement = self.statementBuilder.buildInsertStatement(table, columnNames: Array(values.keys), useNamedParameters: true)
        DDLogVerbose("Executing \(statement) with values: \(values)")
        return try self.database.executeUpdate(statement, parameters: values)
    }

    /// executeUpdate(): Updates zero or more rows in a database table
    /// - Returns: The count of rows updated after execution of the statement
    public func executeUpdate() throws -> Int {
        guard let values = self.contentValues else {
            throw SQLError.MissingContentValues
        }

        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        let hasNamedParameters = self.namedSelectionArgs != nil
        let statement = self.statementBuilder.buildUpdateStatement(
            table,
            updatingColumnNames: Array(values.keys),
            selection: self.selection,
            useNamedParameters: hasNamedParameters
        )

        if hasNamedParameters {
            let mergedValues = self.merge(values, second:self.namedSelectionArgs)
            DDLogVerbose("Executing \(statement) with named parameters: \(mergedValues)")
            return try self.database.executeUpdate(statement, parameters:mergedValues)
        } else {
            DDLogVerbose("Executing \(statement) with parameters: \(self.selectionArgs)")
            return try self.database.executeUpdate(statement, parameters:self.selectionArgs)
        }
    }

    internal func merge(first:[String:AnyObject]?, second:[String:AnyObject]?) -> [String:AnyObject]? {
        if first == nil && second != nil {
            return second
        }

        if second == nil && first != nil {
            return first
        }

        var combined = [String:AnyObject]()
        for (key, value) in first! {
            combined[key] = value
        }

        for (key, value) in second! {
            combined[key] = value
        }

        return combined
    }
}
