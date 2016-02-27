//
// Created by Jeff Roberts on 2/27/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

@testable import SwiftProtocolsSQLite
import Foundation
import XCTest

class SQLStatementBuilderTest : XCTestCase {
    static let TABLE_NAME = "t"
    static let COLUMN_A = "a"
    static let COLUMN_B = "b"
    static let COLUMN_C = "c"
    static let COLUMNS = [COLUMN_A, COLUMN_B, COLUMN_C]

    var statementBuilder : SQLStatementBuilder!

    override func setUp() {
        super.setUp()

        statementBuilder = SQLiteStatementBuilder()
    }

    override func tearDown() {
        super.tearDown()
    }

    // SQL INSERT Tests
    func test_buildInsertStatement_withNamedParameters_generatesValidSQLInsertStatement() {
        let sql = "insert into t (a, b, c) values (:a, :b, :c)"
        let generatedSQL = statementBuilder.buildInsertStatement(SQLStatementBuilderSpec.TABLE_NAME,
                columnNames: SQLStatementBuilderSpec.COLUMNS,
                useNamedParameters: true)
        XCTAssertEqual(generatedSQL.lowercaseString, sql.lowercaseString)
    }

    func test_buildInsertStatement_withParameterMarkers_generatesValidSQLInsertStatement() {
        let sql = "insert into t (a, b, c) values (?, ?, ?)"
        let generatedSQL = statementBuilder.buildInsertStatement(SQLStatementBuilderSpec.TABLE_NAME,
                columnNames: SQLStatementBuilderSpec.COLUMNS,
                useNamedParameters: false)
        XCTAssertEqual(generatedSQL.lowercaseString, sql.lowercaseString)
    }

    // SQL DELETE Tests
    func test_buildDeleteStatement_withoutSelection_generatesValidSQLDeleteStatement() {
        let sql = "delete from t"
        let generatedSQL = statementBuilder.buildDeleteStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    selection: nil)
        XCTAssertEqual(generatedSQL.lowercaseString, sql.lowercaseString)
    }

    func test_buildDeleteStatement_withSelection_generatesValidSQLDeleteStatement() {
        let sql = "delete from t where b = ?"
        let generatedSQL = statementBuilder.buildDeleteStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    selection: "b = ?")
        XCTAssertEqual(generatedSQL.lowercaseString, sql.lowercaseString)
    }

    // SQL UPDATE Tests
    func test_buildUpdateStatement_withNamedParameters_generatesValidSQLUpdateStatement() {
        let sql = "update t set c = :c where b = \"Jeff Roberts\""
        let generatedSQL = statementBuilder.buildUpdateStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    updatingColumnNames: [SQLStatementBuilderSpec.COLUMN_C],
                    selection: "b = \"Jeff Roberts\"",
                    useNamedParameters: true)
        XCTAssertEqual(generatedSQL.lowercaseString, sql.lowercaseString)
    }

    func test_buildUpdateStatement_withParameterMarkers_generatesValidSQLUpdateStatement() {
        let sql = "update t set c = ? where b = \"Jeff Roberts\""
        let generatedSQL = statementBuilder.buildUpdateStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    updatingColumnNames: [SQLStatementBuilderSpec.COLUMN_C],
                    selection: "b = \"Jeff Roberts\"",
                    useNamedParameters: false)
        XCTAssertEqual(generatedSQL.lowercaseString, sql.lowercaseString)
    }

    // SQL SELECT Tests
    func test_buildSelectStatement_withoutProjection_generatesSelectAllForProjection() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: nil,
                    groupBy: nil,
                    having: nil,
                    sort: nil)
        XCTAssertTrue(sql.lowercaseString.hasPrefix("select * from"))
    }

    func test_buildSelectStatement_withProjection_generatesColumnSelectForProjection() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: SQLStatementBuilderSpec.COLUMNS,
                    selection: nil,
                    groupBy: nil,
                    having: nil,
                    sort: nil)
        XCTAssertTrue(sql.lowercaseString.hasPrefix("select a, b, c from"))
    }

    func test_buildSelectStatement_withoutSelection_generatesSelectWithoutWhereClause() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: nil,
                    groupBy: nil,
                    having: nil,
                    sort: nil)
        XCTAssertNil(sql.lowercaseString.rangeOfString("where"))
    }

    func test_buildSelectStatement_withSelection_generatesSelectWithWhereClause() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: "b like :name",
                    groupBy: nil,
                    having: nil,
                    sort: nil)
        XCTAssertNotNil(sql.lowercaseString.rangeOfString("where"))
    }

    func test_buildSelectStatement_withoutGroupBy_generatesSelectWithoutGroupByClause() {
        let sql = statementBuilder.buildSelectStatement(
        SQLStatementBuilderSpec.TABLE_NAME,
                projection: nil,
                selection: nil,
                groupBy: nil,
                having: nil,
                sort: nil)
        XCTAssertNil(sql.lowercaseString.rangeOfString("group by"))
    }

    func test_buildSelectStatement_withGroupBy_generatesSelectWithGroupByClause() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: nil,
                    groupBy: "c",
                    having: nil,
                    sort: nil)
        XCTAssertNotNil(sql.lowercaseString.rangeOfString("group by"))
    }

    func test_buildSelectStatement_withoutHaving_generatesSelectWithoutHavingClause() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: nil,
                    groupBy: nil,
                    having: nil,
                    sort: nil)
        XCTAssertNil(sql.lowercaseString.rangeOfString("having"))
    }

    func test_buildSelectStatement_withHaving_generatesSelectWitHavingClause() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: nil,
                    groupBy: "c",
                    having: "c = 'ios'",
                    sort: nil)
        XCTAssertNotNil(sql.lowercaseString.rangeOfString("having"))
    }

    func test_buildSelectStatement_withoutSort_generatesSelectWithoutOrderByClause() {
        let sql = statementBuilder.buildSelectStatement(
            SQLStatementBuilderSpec.TABLE_NAME,
                    projection: nil,
                    selection: nil,
                    groupBy: nil,
                    having: nil,
                    sort: nil)
        XCTAssertNil(sql.lowercaseString.rangeOfString("order by"))
    }

    func test_buildSelectStatement_withSort_generatesSelectWithOrderByClause() {
        let sql = statementBuilder.buildSelectStatement(
        SQLStatementBuilderSpec.TABLE_NAME,
                projection: nil,
                selection: nil,
                groupBy: nil,
                having: nil,
                sort: "c")
        XCTAssertNotNil(sql.lowercaseString.rangeOfString("order by"))
    }
}
