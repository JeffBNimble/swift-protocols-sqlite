# Introduction
swift-protocols-sqlite is an iOS framework written in Swift 2. It consists of a small handful of protocols that represent very high level SQLite database abstractions and also some utility classes that help when interacting with databases. The database abstractions (things like SQLiteDatabase and Cursor) are expressed as Swift 2 protocols.

# Inspiration
The inspiration behind this framework is that when I was first learning Swift/Swift 2, I wanted to write an application using a SQLite database. I wanted to use a library/framework for interacting with SQLite and so I started playing around with a couple of different libraries. For one reason or another, I kept finding things I didn't like about each and had to keep changing my code to adapt to the API of the other libraries.

I decided instead to spend a bit of time writing an abstraction layer. My application would use these database abstractions and then I could write an adapter to adapt each specific database library/framework to these protocols. That way, I could switch the database libraries in our out at will and since my application had no specific knowledge of the framework, it would just work.

# Adapters
I have only spent the time to adapt the [FMDB](https://github.com/ccgus/fmdb). If anyone wants to create adapters for other SQLite database implementations, please do so, send me a github link to the project and I'll add it to the list below.

* [FMDB Adapter](https://github.com/JeffBNimble/swift-adapters-fmdb) - An FMDB adapter to the protocols in this framework.

# Protocols
The following protocols exist within the framework:

## SQLiteDatabase
[SQLiteDatabase](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/database/SQLiteDatabase.swift) is a simple protocol that describes a single database with functions for initializing, opening, closing, managing transactions and executing SQL statements. Many of the functions are marked as throwing functions.

## Cursor
[Cursor](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/database/Cursor.swift) is a simple protocol that describes a result set from a SQL query. When you execute a query, you get back a Cursor. A Cursor consists of zero or more rows of 1 or more columns. The protocol describes various ways of interacting with the Cursor including getting specific datatypes, getting column names and moving the cursor to specific rows.

## DatabaseFactory
[DatabaseFactory](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/database/DatabaseFactory.swift) is a base class that anyone implementing an adapter framework should subclass as a Factory for producing instances of a conforming SQLiteDatabase.

## SQLiteOpenHelper
[SQLiteOpenHelper](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/database/util/SQLiteOpenHelper.swift) is a protocol that describes a helper for managing your database. If you're an Android developer, you'll find this protocol similar to the [Android counterpart](http://developer.android.com/reference/android/database/sqlite/SQLiteOpenHelper.html). It is used to describe the process of opening and initializing a specific database, following a defined sequence of events and even handling upgrading or downgrading your database schema. There is a base class implementation of the protocol which you can subclass in your own applications [BaseSQLiteOpenHelper](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/database/util/SQLiteOpenHelper.swift#L82)

# Utilities
There are a handful of optional utilities that you can use to make SQLite development easier in your applications. These utilities are written against the protocols above so you can use them with any implementation. You can choose to use them or not as they are not required.

## SQLStatementBuilder
[SQLStatementBuilder](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/sql/SQLStatementBuilder.swift) is a protocol with a provided implementation [SQLiteStatementBuilder](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/sql/SQLStatementBuilder.swift#L55) which makes it easier to construct SQL statements. The statement building interface allows you to easily build INSERT, UPDATE, DELETE and SELECT statements

## SQLiteOperation
[SQLiteOperation](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/sql/SQLiteOperation.swift) is an abstract class that represents an executable SQL statement. An update operation is any operation that updates a SQL database such as a SQL INSERT, UPDATE or DELETE where a query operation is one that queries the database (i.e. SQL SELECT). This class is a base class for the SQLUpdateOperation and SQLQueryOperation.

## SQLUpdateOperation
[SQLUpdateOperation](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/sql/SQLUpdateOperation.swift) is a utility class for easily executing SQL update statements (i.e. INSERT, UPDATE, DELETE). The functions are declared as throwing and will throw any resultant SQL errors from the underlying database implementation. A SQLUpdateOperation is initialized with a SQLiteDatabase and a SQLStatementBuilder). You simply provide information about which database table you wish to update, any content values used to update the data and any selection criteria for selecting which rows to update (SQL UPDATE and DELETE only) and call execute.

**Insert example**

```swift
do {
    let operation = SQLUpdateOperation(database: someSQLiteDatabase, statementBuilder: SQLiteStatementBuilder())
    operation.tableName = "employee"
    operation.contentValues : [String : AnyObject] = ["id" : 123, "first_name" : "Jeff", "last_name" : "Roberts", "status" : "A"]
    let rowId = try operation.executeInsert()
} catch {
  // Do something with the error
}
```

The code above executes
```
INSERT INTO employee (id, first_name, "last_name, "status") VALUES (:id, :first_name, :last_name, :status)
```
using the named parameter values of 123, "Jeff", "Roberts" and "A".

**Update example**

```swift
do {
  let operation = SQLUpdateOperation(database: someSQLiteDatabase, statementBuilder: SQLiteStatementBuilder())
  operation.tableName = "employee"
  operation.selection = "id = :id"
  operation.contentValues : [String : AnyObject] = ["status" : "B"]
  operation.selectionArgs : [String : AnyObject] = ["id" : 123]
  let updateCount = try operation.executeUpdate()
} catch {
  // Do something with the error
}
```

The code above executes
```
UPDATE employee SET status = :status WHERE id = :id
```
using "B" as the updated content value and 123 as the id used in the WHERE clause.

**Delete example**

```swift
do {
  let operation = SQLUpdateOperation(database: someSQLiteDatabase, statementBuilder: SQLiteStatementBuilder())
  operation.tableName = "employee"
  operation.selection = "id = :id"
  operation.selectionArgs : [String : AnyObject] = ["id" : 123]
  let deleteCount = try operation.executeDelete()
} catch {
  // Do something with the error
}
```

The code above executes
```sql
DELETE FROM employee WHERE id = :id
```
using 123 as the parameter

## SQLQueryOperation
[SQLQueryOperation](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/SwiftProtocolsSQLite/sql/SQLQueryOperation.swift) is a utility class for executing SQL queries. The function is throwing and returns a Cursor in response. You can execute simple queries and arbitrarily complex queries using SQL joins, group by and having clauses as well.

**Query example #1**
```swift
do {
  let operation = SQLUpdateOperation(database: someSQLiteDatabase, statementBuilder: SQLiteStatementBuilder())
  operation.tableName = "employee"
  operation.projection = ["id", "last_name", "first_name"]
  operation.sort = "last_name ASC"
  let cursor = try operation.executeQuery()
} catch {
  // Do something with the error
}
```

The code above executes
```sql
SELECT id, last_name, first_name FROM employee ORDER BY last_name ASC
```

**Query example #1**
```swift
do {
  let operation = SQLUpdateOperation(database: someSQLiteDatabase, statementBuilder: SQLiteStatementBuilder())
  operation.tableName = "employee"
  operation.projection = ["count(*) as row_count"]
  operation.selection = "status = :status"
  operation.selectionArgs : [String : AnyObject] = ["status" : "A"]
  let cursor = try operation.executeQuery()
} catch {
  // Do something with the error
}
```

The code above executes
```sql
SELECT count(*) as row_count FROM employee WHERE status = :status
```
using "A" as the selection parameter.

# Installation
Use [Carthage](https://github.com/Carthage/Carthage). This framework requires the use of Swift 2 and XCode 7 or greater.

Specify the following in your Cartfile to use swift-protocols-core:

```github "JeffBNimble/swift-protocols-sqlite" "0.0.13"```

This library/framework has its own set of dependencies and you should use ```carthage update```. The framework dependencies are specified in the [Cartfile](https://github.com/JeffBNimble/swift-protocols-sqlite/blob/master/Cartfile).
