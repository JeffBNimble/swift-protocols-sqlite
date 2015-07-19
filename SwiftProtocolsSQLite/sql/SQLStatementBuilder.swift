//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

/**

**SQLStatementBuilder** builds SQL statements (SELECT, INSERT, UPDATE & DELETE) given a table name
or table clause and other statement-specific inputs.

A tableName can either be a simple name (i.e. "Champions") or a complex table join clause
(i.e. "Champions c JOIN ChampionSkins s on c.id = s.champion_id")

*/

public protocol SQLStatementBuilder {
    /// buildDeleteStatement(tableName:String, selection:String?): Creates a SQL DELETE statement
    /// - Parameter tableName: A simple table name
    /// - Parameter selection: An optional selection clause (i.e. "id = ?") or (i.e. "id = :id")
    /// - Returns: An executable SQL DELETE string (i.e. "DELETE FROM *tableName* WHERE id = ?")
    func buildDeleteStatement(tableName:String, selection:String?) -> String

    /// buildInsertStatement(tableName:String, columnNames:[String], useNamedParameters:Bool): Creates a SQL INSERT statement
    /// - Parameter tableName: A simple table name
    /// - Parameter columnNames: An array of column names (i.e. ["id", "name", "description"])
    /// - Parameter useNamedParameters: A flag indicating whether to use named parameters
    /// - Returns: An executable SQL Insert string (i.e. "INSERT INTO *tableName* (id, name, description) values (?, ?, ?)")
    ///         or (i.e. "INSERT INTO *tableName* (id, name, description) values (:id, :name, :description)")
    func buildInsertStatement(tableName:String, columnNames:[String], useNamedParameters:Bool) -> String

    /// buildSelectStatement(tableName:String, projection:[String]?, selection:String?, groupBy:String?, having:String?, sort:String?): Creates a SQL SELECT statement
    /// - Parameter tableName: A simple table name or a complex table join clause (see class comment)
    /// - Parameter projection: An optional array of columns to include in the resultant cursor (i.e. ["id", "name", "description"]), nil = all columns
    /// - Parameter selection: An optional String containing the where clause (i.e. "id = ? and balance < ?")
    ///         or (i.e. "id = :id and balance < :balance")
    /// - Parameter groupBy: An optional GROUP BY clause (i.e. "champion_type, isOwned")
    /// - Parameter having: An optional HAVING clause (i.e. "champion_type = ? AND isOwned = ?") or (i.e. "champion_type = :championType AND isOwned = :isOwned")
    /// - Parameter sort: An optional ORDER BY clause (i.e. "name asc, power asc)
    /// - Returns: An executable SQL Select statement string (i.e. "SELECT FROM *tableName* WHERE champion_type = :championType ORDER BY name")
    func buildSelectStatement(tableName:String, projection:[String]?, selection:String?, groupBy:String?, having:String?, sort:String?) -> String

    /// buildUpdateStatement(tableName:String, updatingColumnNames:[String], selection:String?, useNamedParameters:Bool): Creates a SQL UPDATE statement
    /// - Parameter tableName: A simple table name
    /// - Parameter updatingColumnNames: An array of column names (i.e. ["isActive", "level"])
    /// - Parameter selection: An optional string selection clause (i.e. "id = ?" or "id = :someId")
    /// - Parameter useNamedParameters: A flag indicating whether to use named parameters
    /// - Returns: An executable SQL Update string (i.e. "UPDATE *tableName* SET isActive = ?, level = ? WHERE id = ?"
    ///         or (i.e. "UPDATE *tableName* SET isActive = :isActive, level = :level WHERE id = :id")
    func buildUpdateStatement(tableName:String, updatingColumnNames:[String], selection:String?, useNamedParameters:Bool) -> String
}

public class SQLiteStatementBuilder:SQLStatementBuilder {
    static private let SELECT:String = "SELECT "
    static private let COUNT:String = "count(*)"
    static private let DELETE:String = "DELETE "
    static private let FROM:String = " FROM "
    static private let GROUP_BY:String = " GROUP BY "
    static private let HAVING:String = " HAVING "
    static private let INSERT_INTO:String = "INSERT INTO "
    static private let ORDER_BY:String = " ORDER BY "
    static private let PROJECTION_ALL:String = "*"
    static private let SET:String = " SET "
    static private let UPDATE:String = "UPDATE "
    static private let WHERE:String = " WHERE "

    public func buildDeleteStatement(tableName: String, selection: String?) -> String {
        var sqlString = "\(SQLiteStatementBuilder.DELETE)\(SQLiteStatementBuilder.FROM)\(tableName)"

        if selection != nil && !selection!.isEmpty {
            sqlString += "\(SQLiteStatementBuilder.WHERE)\(selection)"
        }

        return sqlString;
    }

    public func buildInsertStatement(tableName: String, columnNames: [String], useNamedParameters: Bool = true) -> String {
        let names = ",".join(columnNames)
        let values = columnNames.map() {columnName in
            useNamedParameters ? ":\(columnName)" : "?"
        }
        let valuesString = ",".join(values)

        return "\(SQLiteStatementBuilder.INSERT_INTO) (\(names)) VALUES (\(valuesString))"
    }

    public func buildSelectStatement(tableName: String, projection: [String]?, selection: String?, groupBy: String?, having: String?, sort: String?) -> String {

        let projectionColumns = projection ?? [SQLiteStatementBuilder.PROJECTION_ALL]

        let projectionString = ",".join(projectionColumns)

        var sqlString = "\(SQLiteStatementBuilder.SELECT)\(projectionString)\(SQLiteStatementBuilder.FROM)\(tableName)"

        if selection != nil && !selection!.isEmpty {
            sqlString += "\(SQLiteStatementBuilder.WHERE)\(selection)"
        }

        if groupBy != nil && !groupBy!.isEmpty {
            sqlString += "\(SQLiteStatementBuilder.GROUP_BY)\(groupBy)"
        }

        if having != nil && !having!.isEmpty {
            sqlString += "\(SQLiteStatementBuilder.HAVING)\(having)"
        }

        if sort != nil && !sort!.isEmpty {
            sqlString += "\(SQLiteStatementBuilder.ORDER_BY)\(sort)"
        }

        return sqlString
    }

    public func buildUpdateStatement(tableName: String, updatingColumnNames: [String], selection: String?, useNamedParameters: Bool = true) -> String {
        let columnNames = updatingColumnNames.map() {columnName in
            useNamedParameters ? "\(columnName) = :\(columnName)" : "\(columnName) = ?"
        }

        let setClause = ",".join(columnNames)
        var sqlString = "\(SQLiteStatementBuilder.UPDATE)\(tableName)\(SQLiteStatementBuilder.SET)\(setClause)"

        if selection != nil && !selection!.isEmpty  {
            sqlString += "\(SQLiteStatementBuilder.WHERE)\(selection)"
        }

        return sqlString;
    }
}