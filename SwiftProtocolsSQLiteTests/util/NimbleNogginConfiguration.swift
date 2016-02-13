//
// Created by Jeffrey Roberts on 2/12/16.
// Copyright (c) 2016 NimbleNoggin.io. All rights reserved.
//

import Foundation
import Quick

public var currentExampleFailed = false

public class NimbleNogginConfiguration : QuickConfiguration {
    static var groups:NSMutableDictionary = NSMutableDictionary()

    override public static func configure(configuration: Configuration) {
        configuration.beforeEach() { (metadata:ExampleMetadata) in
            currentExampleFailed = false
        }

        configuration.afterEach() { (metadata:ExampleMetadata) in
            let segments = metadata.example.name.componentsSeparatedByString(",")

            var currentGroup = groups
            var previousGroup = groups
            var trimmedSegment:String!
            segments.forEach() { segment in
                trimmedSegment = segment.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if currentGroup[trimmedSegment] != nil {
                    currentGroup = currentGroup[trimmedSegment] as! NSMutableDictionary
                } else {
                    previousGroup = currentGroup
                    currentGroup[trimmedSegment] = NSMutableDictionary()
                    currentGroup = currentGroup[trimmedSegment] as! NSMutableDictionary
                }
            }

            previousGroup[trimmedSegment] = currentExampleFailed ? "F" : "P"
        }

        configuration.afterSuite() {
            printTestResults(groups, prefix: "")
        }
    }

    private static func printTestResults(results : NSDictionary, prefix : String = "") {
         results.allKeys.forEach() { key in
            if let segment = key as? String {
                var testResult = ""
                var value = results[segment]

                if let result = value as? String {
                    testResult = result == "P" ? "\u{001B}[1m\u{001B}[032;m[PASSED]\u{001B}[0m" : "\u{001B}[1m\u{001B}[031;m[FAILED]\u{001B}[0m"
                }

                print("\(prefix)\(segment) \(testResult)")

                if let segments = value as? NSDictionary {
                    printTestResults(segments, prefix: "\(prefix)\t")
                }
            }
         }
    }

}
