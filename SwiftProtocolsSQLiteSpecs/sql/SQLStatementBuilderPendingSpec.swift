//
// Created by Jeff Roberts on 2/5/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

@testable import SwiftProtocolsSQLite
import Quick
import Nimble

class SQLStatementBuilderPendingSpec : QuickSpec {
    override func spec() {
        describe("Given a SQLStatementBuilder") {

            // SQL INSERT
            context("when building an INSERT statement") {

                context("with named parameters") {

                    pending("then it should generate a valid SQL INSERT statement") {}

                }

                context("with parameter markers") {

                    pending("then it should generate a valid SQL INSERT statement") {}

                }
            }

            // SQL DELETE
            context("when building a DELETE statement") {

                context("without a selection specified") {

                    pending("then it should generate a valid SQL DELETE statement without a WHERE clause") {}

                }

                context("with a selection specified") {

                    pending("then it should generate a valid SQL DELETE statement with a WHERE clause") {}

                }
            }

            // SQL UPDATE
            context("when building an UPDATE statement") {

                context("with named parameters") {

                    pending("then it should generate a valid SQL UPDATE statement") {}

                }

                context("with parameter markers") {

                    pending("then it should generate a valid SQL UPDATE statement") {}

                }
            }

            // SQL SELECT
            context("when building a SELECT statement") {

                context("without a projection specified") {

                    pending("then it should generate '*' for the projection") {}

                }

                context("with a projection specified") {

                    pending("then it should generate a selection clause for each column in the projection") {}

                }

                context("without a selection specified") {

                    pending("then it should not generate a WHERE clause") {}

                }

                context("with a selection specified") {

                    pending("then it should generate a valid WHERE clause") {}

                }

                context("without a group by specified") {

                    pending("then it should not generate a GROUP BY clause") {}

                }

                context("with a group by specified") {

                    pending("then it should generate a valid GROUP BY clause") {}

                }

                context("without a having specified") {

                    pending("then it should not generate a HAVING clause") {}

                }

                context("with a having specified") {

                    pending("then it should generate a valid HAVING clause") {}

                }

                context("without a sort specified") {

                    pending("then it should not generate an ORDER BY clause") {}

                }

                context("with a sort specified") {

                    pending("then it should generate a valid ORDER BY clause") {}
                }
            }
        }
    }

}
