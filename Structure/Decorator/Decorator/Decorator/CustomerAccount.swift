//
//  CustomerAccount.swift
//  Decorator
//
//  Created by HungDo on 8/1/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

class CustomerAccount {
    let customerName: String
    var purchases = [Purchase]()
    
    init(name: String) {
        self.customerName = name
    }
    
    func addPurchase(purchase: Purchase) {
        self.purchases.append(purchase)
    }
    
    func printAccount() {
        var total: Float = 0
        for p in purchases {
            total += p.totalPrice
            print("Purchase \(p), Price \(formatCurrencyString(p.totalPrice))")
        }
        print("Total due: \(formatCurrencyString(total))")
    }
    
    func formatCurrencyString(number: Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter.stringFromNumber(number) ?? ""
    }
}