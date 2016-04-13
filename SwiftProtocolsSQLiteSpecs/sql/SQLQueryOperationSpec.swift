//
// Created by Jeffrey Roberts on 2/8/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

@testable import SwiftProtocolsSQLite
import Quick
import Nimble

class SQLQueryOperationSpec : QuickSpec {
    override func spec() {
        describe("Given a SQLQueryOperation") {

            var queryOperation : SQLQueryOperation!
            var sqlStatementBuilder : SQLStatementBuilder!
            var mockDatabase : SQLiteDatabase!

            beforeEach {
                mockDatabase = MockSQLiteDatabase(path: "")
                sqlStatementBuilder = SQLiteStatementBuilder()
                queryOperation = SQLQueryOperation(database: mockDatabase, statementBuilder: sqlStatementBuilder)
            }

            context("when executing a query without a table") {

                it("then it will throw a MissingTableName exception") {
                    expect{try queryOperation.executeQuery()}.to(throwError(SQLError.MissingTableName))
                }
            }

            context("when executing a query with named parameters") {

                it("then it will execute the query against the database") {
                    queryOperation.tableName = "myTable"
                    queryOperation.namedSelectionArgs = ["platform": "ios"]
                    do { try queryOperation.executeQuery() } catch _ { fail("No exception expected") }

                    self.expectSqlQuery("select * from mytable",
                            withNamedParameters: queryOperation.namedSelectionArgs!,
                            againstDatabase: mockDatabase)
                }

            }

            context("when executing a query with an array of parameters") {

                it("then it will execute the query against the database") {
                    queryOperation.tableName = "myTable"
                    queryOperation.selectionArgs = ["ios"]
                    do { try queryOperation.executeQuery() } catch _ { fail("No exception expected") }

                    self.expectSqlQuery("select * from mytable",
                            withParameters: queryOperation.selectionArgs!,
                            againstDatabase: mockDatabase)
                }
            }

        }
    }

    override internal func recordFailureWithDescription(description: String, inFile filePath: String, atLine lineNumber: UInt, expected isExpected: Bool) {
        currentExampleFailed = true
        super.recordFailureWithDescription(description, inFile: filePath, atLine: lineNumber, expected: isExpected)
    }

    private func expectSqlQuery(queryString: String, withNamedParameters parameters: [String : AnyObject], againstDatabase database: SQLiteDatabase) {
        guard let db = database as? MockSQLiteDatabase else {
            fail("Unexpected test failure")
            return
        }

        expectSqlQuery(queryString, wasExecutedAgainstDatabase: database)
        expect(db.namedParameters).to(haveCount(parameters.count))

        db.namedParameters?.forEach() {
            key, value in
            expect(parameters.keys).to(contain(key))
            expect(parameters[key] as? String).to(equal(value as? String))
        }
    }

    private func expectSqlQuery(queryString: String, withParameters parameters: [AnyObject], againstDatabase database: SQLiteDatabase) {
        guard let db = database as? MockSQLiteDatabase else {
            fail("Unexpected test failure")
            return
        }

        expectSqlQuery(queryString, wasExecutedAgainstDatabase: database)
        expect(db.parameterArray).to(haveCount(parameters.count))

        db.parameterArray?.forEach() { value in
            expect(parameters).to(contain(value))
        }
    }

    private func expectSqlQuery(queryString: String, wasExecutedAgainstDatabase database:SQLiteDatabase) {
        guard let db = database as? MockSQLiteDatabase else {
            fail("Unexpected test failure")
            return
        }

        expect(queryString.lowercaseString).to(equal(db.sqlString?.lowercaseString))
    }
}
