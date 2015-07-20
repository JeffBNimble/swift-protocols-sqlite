//
// Created by Jeffrey Roberts on 7/12/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

/**
 * Cursor represents a collection of zero or more rows. Each row contains 1 or more
 * columns identified either by index or name. Each column contains data of a specific
 * type. The cursor can be positioned forward, backward, relatively, absolutely and to the
 * first and last rows. When finished with a Cursor, it should be closed.
 */
public protocol Cursor {
    /// boolFor: Answer the boolean value at the specified column name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The Bool value at the requested column
    func boolFor(columnName:String) -> Bool
    
    /// boolFor: Answer the boolean value at the specified column name
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The Bool value at the requested column
    func boolFor(columnIndex:Int) -> Bool
    
    /// close: Close the cursor
    /// Returns: void
    func close() -> Void
    
    /// columnCount: The number of columns in the cursor
    /// Returns: The number of columns in this cursor
    func columnCount() -> Int
    
    /// columnIndexFor: Answer the index of the specified column name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The index at the requested column or -1 if no such column
    func columnIndexFor(columnName:String) -> Int
    
    /// columnAtIndexIsNull: Answer whether the specified column has a null value
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: A Bool indicating whether the column value is null
    func columnAtIndexIsNull(columnIndex:Int) -> Bool
    
    /// columnIsNull: Answer whether the specified column has a null value
    /// Parameter columnName: The name of the column being referenced
    /// Returns: A Bool indicating whether the column value is null
    func columnIsNull(columnName:String) -> Bool
    
    /// columnNameFor: Answer the name of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The name of the requested column
    func columnNameFor(columnIndex:Int) -> String
    
    /// dataFor: Answer the NSData value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The NSData value of the requested column
    func dataFor(columnName:String) -> NSData
    
    /// dataFor: Answer the NSData value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The NSData value of the requested column
    func dataFor(columnIndex:Int) -> NSData
    
    /// dateFor: Answer the NSDate value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The NSDate value of the requested column
    func dateFor(columnName:String) -> NSDate
    
    /// dateFor: Answer the NSDate value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The NSDate value of the requested column
    func dateFor(columnIndex:Int) -> NSDate
    
    /// doubleFor: Answer the Double value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The Double value of the requested column
    func doubleFor(columnName:String) -> Double
    
    /// doubleFor: Answer the Double value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The Double value of the requested column
    func doubleFor(columnIndex:Int) -> Double
    
    /// intFor: Answer the Int value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The Int value of the requested column
    func intFor(columnName:String) -> Int
    
    /// intFor: Answer the Int value of the column at the specified index
    /// Parameter columnIndex: The indix of the column being referenced
    /// Returns: The Int value of the requested column
    func intFor(columnIndex:Int) -> Int
    
    /// longFor: Answer the Int32 value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The Int32 value of the requested column
    func longFor(columnName:String) -> Int32
    
    /// longFor: Answer the Int32 value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The Int32 value of the requested column
    func longFor(columnIndex:Int) -> Int32
    
    /// longLongFor: Answer the Int64 value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The Int64 value of the requested column
    func longLongIntFor(columnName:String) -> Int64
    
    /// longLongFor: Answer the Int64 value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The Int64 value of the requested column
    func longLongIntFor(columnIndex:Int) -> Int64
    
    /// move: Move the row pointer forward or backward a specified number of rows
    /// Parameter offset: The number of rows to move, negative numbers move backward, positive numbers move forward
    /// Returns: A Bool indicating whether the row pointer was moved
    func move(offset:Int) -> Bool
    
    /// moveToFirst: Move the row pointer to the first row
    /// Returns: A Bool indicating whether the row pointer was moved
    func moveToFirst() -> Bool
    
    /// moveToLast: Move the row pointer to the last row
    /// Returns: A Bool indicating whether the row pointer was moved
    func moveToLast() -> Bool
    
    /// moveToPosition: Move the row pointer to a specified row
    /// Parameter absolutePosition: The position of the row to move the row pointer to
    /// Returns: A Bool indicating whether the row pointer was moved
    func moveToPosition(absolutePosition:Int) -> Bool
    
    /// next: Move the row pointer to the next row
    /// Returns: A Bool indicating whether the row pointer was moved
    func next() -> Bool
    
    /// previous: Move the row pointer to the previous row
    /// Returns: A Bool indicating whether the row pointer was moved
    func previous() -> Bool
    
    /// stringFor: Answer the String value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The String value of the requested column
    func stringFor(columnName:String) -> String
    
    /// stringFor: Answer the String value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The String value of the requested column
    func stringFor(columnIndex:Int) -> String
    
    /// unsignedLongLongIntFor: Answer the UInt64 value of the column at the specified name
    /// Parameter columnName: The name of the column being referenced
    /// Returns: The UInt64 value of the requested column
    func unsignedLongLongIntFor(columnName:String) -> UInt64
    
    /// unsignedLongLongIntFor: Answer the UInt64 value of the column at the specified index
    /// Parameter columnIndex: The index of the column being referenced
    /// Returns: The UInt64 value of the requested column
    func unsignedLongLongIntFor(columnIndex:Int) -> UInt64
}
