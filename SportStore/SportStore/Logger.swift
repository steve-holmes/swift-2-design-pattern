//
//  Logger.swift
//  SportStore
//
//  Created by HungDo on 7/29/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

let productLogger = Logger<Product>(callback: { p in
    var builder         = ChangeRecordBuilder()
    builder.productName = p.name
    builder.category    = p.category
    builder.value       = String(p.stockLevel)
    builder.outerTag    = "stockChange"
    
    if let changeRecord = builder.changeRecord {
        print(changeRecord)
    }
})

final class Logger<T where T:NSObject, T:NSCopying> {
    
    var dataItems: [T] = []
    var callback: (T) -> Void
    var arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_CONCURRENT)
    var callbackQ = dispatch_queue_create("callbackQ", DISPATCH_QUEUE_SERIAL)
    
    private init(callback: T -> Void, protect: Bool = true) {
        self.callback = callback
        if protect {
            self.callback = { (item: T) in
                dispatch_sync(self.callbackQ) {
                    callback(item)
                }
            }
        }
    }
    
    func logItem(item: T) {
        dispatch_barrier_async(arrayQ) { 
            self.dataItems.append(item.copy() as! T)
            self.callback(item)
        }
    }
    
    func processItems(callback: T -> Void) {
        dispatch_sync(arrayQ) {
            for item in self.dataItems {
                callback(item)
            }
        }
    }
    
}