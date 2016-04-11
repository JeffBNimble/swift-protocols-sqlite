//
// Created by Jeffrey Roberts on 2/7/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

@testable import SwiftProtocolsSQLite
import Quick
import Nimble

class SQLQueryOperationPendingSpec : QuickSpec {
    override func spec() {
        describe("With a SQLQueryOperation") {

            context("when executing a query without a table") {

                pending("it will throw a MissingTableName exception") {}

            }

            context("when executing a query with named parameters") {

                pending("it will execute the query against the database") {}

            }

            context("when executing a query with an array of parameters") {

                pending("it will execute the query against the database") {}
            }

        }
    }
}
