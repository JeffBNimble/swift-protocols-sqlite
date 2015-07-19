//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

/**

**SQLUpdateOperation** represents a SQL INSERT, UPDATE or DELETE operation that either inserts, updates
or deletes in a single database table.

*/

class SQLUpdateOperation: SQLiteOperation {
    /// An optional map of values that will be inserted/updated where the key is the column name and
    /// the value is the column value
    var contentValues:[String: AnyObject]?

    override init(database: SQLiteDatabase, statementBuilder: SQLStatementBuilder) {
        super.init(database: database, statementBuilder: statementBuilder)
    }

    /// executeDelete(): Deletes zero or more rows from a database table
    /// - Returns: The count of rows deleted after execution of the statement
    func executeDelete() throws -> Int {
        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        return try(
            self.database.executeUpdate(self.statementBuilder.buildDeleteStatement(table, selection: self.selection),
                parameters:self.selectionArgs)
        )
    }

    /// executeInsert(): Inserts a row into a database table
    /// - Returns: The count of rows inserted after execution of the statement, should be 1
    func executeInsert() throws -> Int {
        guard let values = self.contentValues else {
            throw SQLError.MissingContentValues
        }

        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        return try(
            self.database.executeUpdate(
                self.statementBuilder.buildInsertStatement(
                    table,
                    columnNames: values.keys.array,
                    useNamedParameters: true),
                parameters: values
            )
        )
    }

    /// executeUpdate(): Updates zero or more rows in a database table
    /// - Returns: The count of rows updated after execution of the statement
    func executeUpdate() throws -> Int {
        guard let values = self.contentValues else {
            throw SQLError.MissingContentValues
        }

        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        let hasNamedParameters = self.namedSelectionArgs != nil
        let statement = self.statementBuilder.buildUpdateStatement(
            table,
            updatingColumnNames: values.keys.array,
            selection: self.selection,
            useNamedParameters: hasNamedParameters
        )

        return hasNamedParameters ?
            try(self.database.executeUpdate(statement, parameters:self.merge(values, second:self.namedSelectionArgs)))
            :
            try(self.database.executeUpdate(statement, parameters:self.selectionArgs)
        )
    }

    internal func merge(first:[String:AnyObject?]?, second:[String:AnyObject?]?) -> [String:AnyObject?]? {
        if first == nil && second != nil {
            return second
        }

        if second == nil && first != nil {
            return first
        }

        var combined = [String:AnyObject?]()
        for (key, value) in first! {
            combined[key] = value
        }

        for (key, value) in second! {
            combined[key] = value
        }

        return combined
    }
}
