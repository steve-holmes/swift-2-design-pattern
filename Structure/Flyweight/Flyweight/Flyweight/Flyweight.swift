//
//  Flyweight.swift
//  Flyweight
//
//  Created by HungDo on 8/2/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

protocol Flyweight {
    subscript(index: Coordinate) -> Int? { get set }
    var total: Int { get }
    var count: Int { get }
}

extension Dictionary {
    init(setupFunc: () -> [(Key, Value)]) {
        self.init()
        for item in setupFunc() {
            self[item.0] = item.1
        }
    }
}

class FlyweightFactory {
    class func createFlyweight() -> Flyweight {
        return FlyweightImplementation(extrinsic: extrinsicData)
    }
    
    private class var extrinsicData: [Coordinate : Cell] {
        struct SingletonWrapper {
            static let singletonData = [Coordinate:Cell](setupFunc: {
                var results = [(Coordinate, Cell)]()
                let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                var stringIndex = letters.startIndex
                let rows = 50
                repeat {
                    let colLetter = letters[stringIndex]
                    stringIndex = stringIndex.successor()
                    for rowIndex in 1 ... rows {
                        let cell = Cell(col: colLetter, row: rowIndex, val: rowIndex)
                        results.append((cell.coordinate, cell))
                    }
                } while stringIndex != letters.endIndex
                return results
            })
        }
        return SingletonWrapper.singletonData
    }
}

class FlyweightImplementation: Flyweight {
    private let extrinsicData: [Coordinate : Cell]
    private var intrinsicData: [Coordinate : Cell]
    private let queue: dispatch_queue_t
    
    private init(extrinsic: [Coordinate : Cell]) {
        self.extrinsicData = extrinsic
        self.intrinsicData = [Coordinate:Cell]()
        self.queue = dispatch_queue_create("dataQ", DISPATCH_QUEUE_CONCURRENT)
    }
    
    subscript(key: Coordinate) -> Int? {
        get {
            var result: Int?
            dispatch_sync(self.queue) {
                if let cell = self.intrinsicData[key] {
                    result = cell.value
                } else {
                    result = self.extrinsicData[key]?.value
                }
            }
            return result
        }
        set(value) {
            if value != nil {
                dispatch_barrier_sync(self.queue) {
                    self.intrinsicData[key] = Cell(col: key.col, row: key.row, val: value!)
                }
            }
        }
    }
    
    var total: Int {
        var result = 0
        dispatch_sync(self.queue) {
            result = self.extrinsicData.values.reduce(0) { (total, cell) in
                if let intrinsicCell = self.intrinsicData[cell.coordinate] {
                    return total + intrinsicCell.value
                } else {
                    return total + cell.value
                }
            }
        }
        return result
    }
    
    var count: Int {
        var result = 0
        dispatch_sync(self.queue) {
            result = self.intrinsicData.count
        }
        return result
    }
}