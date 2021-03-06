//
//  main.swift
//  Composite
//
//  Created by HungDo on 8/1/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

let doorWindow = CompositePart(name: "DoorWindow", parts:
    Part(name: "Window", price: 100.50),
    Part(name: "Window Switch", price: 12)
)

let door = CompositePart(name: "Door", parts:
    doorWindow,
    Part(name: "Door Loom", price: 80),
    Part(name: "Door Handler", price: 43.40)
)

let hood = Part(name: "Hood", price: 320)

let order = CustomerOrder(customer: "Bob", parts: [hood, door, doorWindow])
order.printDetails()