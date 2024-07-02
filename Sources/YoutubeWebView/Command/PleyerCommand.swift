//
//  PleyerCommand.swift
//  
//
//  Created by Goston Wu on 29/6/2024.
//

import Foundation

public enum PleyerCommand: ~Copyable {
    case play
    case stop
    case pause
    case forward(Int) // Positive = fast forward, Negative = rewind
}
