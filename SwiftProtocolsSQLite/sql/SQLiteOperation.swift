//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

/**

**SQLiteOperation** is an abstract class that represents an executable SQL operation (ie a SQL INSERT,
UPDATE, DELETE or SELECT).

A tableName can either be a simple name (i.e. "Champions") or a complex table join clause
(i.e. "Champions c JOIN ChampionSkins s on c.id = s.champion_id"), but it must be appropriate for the
statement being executed.

The *selection* and *selectionArgs* optional properties can be used by all subclasses, though aren't
ever used for SQL INSERT.

*/

class SQLiteOperation {
    /// The optional named arguments that get bound into the named parameters of the selection. If specified, the
    /// number of elements must equal the number of named parameters in the *selection*. The values will get
    /// bound using the keys
    /// *selection*
    var namedSelectionArgs:[String:AnyObject]?

    /// The optional selection for the SQL statement. If specified, you generally want this to be the
    /// parameterized WHERE clause not including the WHERE itself. The following is an example of a selection:
    /// ```"id = ? AND name = ?" using parameter markers. If you choose to use named parameters, a similar example is:
    /// ```"id = :id AND name = :name".
    var selection:String?

    /// The optional arguments that get bound into the parameter markers of the selection. If specified, the
    /// number of elements must equal the number of parameter markers in the *selection*. The values will get
    /// bound in the order specified in the array so ensure that the order matches the order expected in the
    /// *selection*
    var selectionArgs:[AnyObject]?

    /// The name of the table against which the operation will occur. See the class description for more details
    /// on the *tableName*
    var tableName:String?

    internal var database:SQLiteDatabase
    internal var statementBuilder:SQLStatementBuilder

    init(database: SQLiteDatabase, statementBuilder: SQLStatementBuilder) {
        self.database = database
        self.statementBuilder = statementBuilder
    }
}

enum SQLError:ErrorType {
    case MissingContentValues
    case MissingTableName
}
