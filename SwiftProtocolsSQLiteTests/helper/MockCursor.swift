//
// Created by Jeffrey Roberts on 2/8/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

import SwiftProtocolsSQLite

class MockCursor : Cursor {
    func boolFor(columnName: String) -> Bool {
        return false
    }

    func boolFor(columnIndex: Int) -> Bool {
        return false
    }

    func close() {
    }

    func columnCount() -> Int {
        return 0
    }

    func columnIndexFor(columnName: String) -> Int {
        return 0
    }

    func columnAtIndexIsNull(columnIndex: Int) -> Bool {
        return false
    }

    func columnIsNull(columnName: String) -> Bool {
        return false
    }

    func columnNameFor(columnIndex: Int) -> String {
        return ""
    }

    func dataFor(columnName: String) -> NSData {
        var data:NSData!
        do {
            data = try NSData(contentsOfFile: "", options: NSDataReadingOptions.DataReadingUncached)
        } catch _ {}

        return data;
    }

    func dataFor(columnIndex: Int) -> NSData {
        var data:NSData!
        do {
            data = try NSData(contentsOfFile: "", options: NSDataReadingOptions.DataReadingUncached)
        } catch _ {}

        return data
    }

    func dateFor(columnName: String) -> NSDate {
        return NSDate()
    }

    func dateFor(columnIndex: Int) -> NSDate {
        return NSDate()
    }

    func doubleFor(columnName: String) -> Double {
        return 0
    }

    func doubleFor(columnIndex: Int) -> Double {
        return 0
    }

    func intFor(columnName: String) -> Int {
        return 0
    }

    func intFor(columnIndex: Int) -> Int {
        return 0
    }

    func longFor(columnName: String) -> Int32 {
        return 0
    }

    func longFor(columnIndex: Int) -> Int32 {
        return 0
    }

    func longLongIntFor(columnName: String) -> Int64 {
        return 0
    }

    func longLongIntFor(columnIndex: Int) -> Int64 {
        return 0
    }

    func move(offset: Int) -> Bool {
        return false
    }

    func moveToFirst() -> Bool {
        return false
    }

    func moveToLast() -> Bool {
        return false
    }

    func moveToPosition(absolutePosition: Int) -> Bool {
        return false
    }

    func next() -> Bool {
        return false
    }

    func previous() -> Bool {
        return false
    }

    func stringFor(columnName: String) -> String {
        return ""
    }

    func stringFor(columnIndex: Int) -> String {
        return ""
    }

    func unsignedLongLongIntFor(columnName: String) -> UInt64 {
        return 0
    }

    func unsignedLongLongIntFor(columnIndex: Int) -> UInt64 {
        return 0
    }

}
