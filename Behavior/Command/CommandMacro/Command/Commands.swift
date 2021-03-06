//
//  Commands.swift
//  Command
//
//  Created by HungDo on 8/3/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

protocol Command {
    func execute(receiver: Any)
}

class CommandWrapper: Command {
    private let commands: [Command]
    
    init(commands: [Command]) {
        self.commands = commands
    }
    
    func execute(receiver: Any) {
        for command in commands {
            command.execute(receiver)
        }
    }
}

class GenericCommand<T>: Command {
    private var instructions: T -> Void
    
    init(instructions: T -> Void) {
        self.instructions = instructions
    }
    
    func execute(receiver: Any) {
        if let safeReceiver = receiver as? T {
            instructions(safeReceiver)
        } else {
            fatalError("Receiver is not expected type")
        }
    }
    
    class func createCommand(instructions: T -> Void) -> Command {
        return GenericCommand(instructions: instructions)
    }
}