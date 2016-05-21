//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation
import SwiftyBeaver

@objc
public class SQLQueryOperation : SQLiteOperation {
    private let logger = SwiftyBeaver.self

    public var groupBy:String?
    public var having:String?
    public var projection:[String]?
    public var sort:String?

    public override init(database: SQLiteDatabase, statementBuilder: SQLStatementBuilder) {
        super.init(database: database, statementBuilder: statementBuilder)
    }

    public func executeQuery() throws -> Cursor {
        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        let statement = self.statementBuilder.buildSelectStatement(table,
                projection: self.projection,
                selection: self.selection,
                groupBy: self.groupBy,
                having: self.having,
                sort: self.sort)
        let hasNamedParameters = self.namedSelectionArgs != nil
        if hasNamedParameters {
            logger.debug("Executing \(statement) with named parameters: \(self.namedSelectionArgs)")
            return try self.database.executeQuery(statement, parameters:self.namedSelectionArgs)
        } else {
            logger.debug("Executing \(statement) with parameters: \(self.selectionArgs)")
            return try self.database.executeQuery(statement, parameters:self.selectionArgs)
        }
    }
}
