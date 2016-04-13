//
// Created by Jeffrey Roberts on 2/7/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

@testable import SwiftProtocolsSQLite
import Quick
import Nimble

class SQLStatementBuilderSpec : QuickSpec {
    static let TABLE_NAME = "t"
    static let COLUMN_A = "a"
    static let COLUMN_B = "b"
    static let COLUMN_C = "c"
    static let COLUMNS = [COLUMN_A, COLUMN_B, COLUMN_C]

    override func spec() {
        describe("Given a SQLStatementBuilder") {
            var statementBuilder : SQLStatementBuilder!

            beforeEach {
                statementBuilder = SQLiteStatementBuilder()
            }

            // SQL INSERT
            context("when building an INSERT statement") {

                context("with named parameters") {

                    it("then it should generate a valid SQL INSERT statement") {
                        let sql = "insert into t (a, b, c) values (:a, :b, :c)"
                        let generatedSQL = statementBuilder.buildInsertStatement(SQLStatementBuilderSpec.TABLE_NAME,
                                columnNames: SQLStatementBuilderSpec.COLUMNS,
                                useNamedParameters: true)
                        expect(generatedSQL.lowercaseString).to(equal(sql.lowercaseString))
                    }

                }

                context("with parameter markers") {

                    it("then it should generate a valid SQL INSERT statement") {
                        let sql = "insert into t (a, b, c) values (?, ?, ?)"
                        let generatedSQL = statementBuilder.buildInsertStatement(SQLStatementBuilderSpec.TABLE_NAME,
                                columnNames: SQLStatementBuilderSpec.COLUMNS,
                                useNamedParameters: false)
                        expect(generatedSQL.lowercaseString).to(equal(sql.lowercaseString))
                    }

                }
            }

            // SQL DELETE
            context("when building a DELETE statement") {

                context("without a selection specified") {

                    it("then it should generate a valid SQL DELETE statement without a WHERE clause") {
                        let sql = "delete from t"
                        let generatedSQL = statementBuilder.buildDeleteStatement(
                            SQLStatementBuilderSpec.TABLE_NAME,
                            selection: nil)
                        expect(generatedSQL.lowercaseString).to(equal(sql.lowercaseString))
                    }

                }

                context("with a selection specified") {

                    it("then it should generate a valid SQL DELETE statement with a WHERE clause") {
                        let sql = "delete from t where b = ?"
                        let generatedSQL = statementBuilder.buildDeleteStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                selection: "b = ?")
                        expect(generatedSQL.lowercaseString).to(equal(sql.lowercaseString))
                    }

                }
            }

            // SQL UPDATE
            context("when building an UPDATE statement") {

                context("with named parameters") {

                    it("then it should generate a valid SQL UPDATE statement") {
                        let sql = "update t set c = :c where b = \"Jeff Roberts\""
                        let generatedSQL = statementBuilder.buildUpdateStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                updatingColumnNames: [SQLStatementBuilderSpec.COLUMN_C],
                                selection: "b = \"Jeff Roberts\"",
                                useNamedParameters: true)
                        expect(generatedSQL.lowercaseString).to(equal(sql.lowercaseString))
                    }

                }

                context("with parameter markers") {

                    it("then it should generate a valid SQL UPDATE statement") {
                        let sql = "update t set c = ? where b = \"Jeff Roberts\""
                        let generatedSQL = statementBuilder.buildUpdateStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                updatingColumnNames: [SQLStatementBuilderSpec.COLUMN_C],
                                selection: "b = \"Jeff Roberts\"",
                                useNamedParameters: false)
                        expect(generatedSQL.lowercaseString).to(equal(sql.lowercaseString))
                    }

                }
            }

            // SQL SELECT
            context("when building a SELECT statement") {

                context("without a projection specified") {

                    it("then it should generate '*' for the projection") {
                        let sql = statementBuilder.buildSelectStatement(
                            SQLStatementBuilderSpec.TABLE_NAME,
                            projection: nil,
                            selection: nil,
                            groupBy: nil,
                            having: nil,
                            sort: nil)
                        expect(sql.lowercaseString).to(beginWith("select * from"))
                    }

                }

                context("with a projection specified") {

                    it("then it should generate a selection clause for each column in the projection") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: SQLStatementBuilderSpec.COLUMNS,
                                selection: nil,
                                groupBy: nil,
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).to(beginWith("select a, b, c from"))
                    }

                }

                context("without a selection specified") {

                    it("then it should not generate a WHERE clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: nil,
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).toNot(contain("where"))
                    }

                }

                context("with a selection specified") {

                    it("then it should generate a valid WHERE clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: "b like :name",
                                groupBy: nil,
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).to(contain("where"))
                    }

                }

                context("without a group by specified") {

                    it("then it should not generate a GROUP BY clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: nil,
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).toNot(contain("group by"))
                    }

                }

                context("with a group by specified") {

                    it("then it should generate a valid GROUP BY clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: "c",
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).to(contain("group by"))
                    }

                }

                context("without a having specified") {

                    it("then it should not generate a HAVING clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: nil,
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).toNot(contain("having"))
                    }

                }

                context("with a having specified") {

                    it("then it should generate a valid HAVING clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: "c",
                                having: "c = 'ios'",
                                sort: nil)
                        expect(sql.lowercaseString).to(contain("having"))
                    }

                }

                context("without a sort specified") {

                    it("then it should not generate an ORDER BY clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: nil,
                                having: nil,
                                sort: nil)
                        expect(sql.lowercaseString).toNot(contain("order by"))
                    }

                }

                context("with a sort specified") {

                    it("then it should generate a valid ORDER BY clause") {
                        let sql = statementBuilder.buildSelectStatement(
                        SQLStatementBuilderSpec.TABLE_NAME,
                                projection: nil,
                                selection: nil,
                                groupBy: nil,
                                having: nil,
                                sort: "c")
                        expect(sql.lowercaseString).to(contain("order by"))
                    }
                }
            }
        }
    }
}
