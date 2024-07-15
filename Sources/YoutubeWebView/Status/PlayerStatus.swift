//
//  PlayerStatus.swift
//  
//
//  Created by Goston Wu on 29/6/2024.
//

import Foundation

public enum PlayerStatus: ~Copyable {
    case loaded
    case playing
    case buffering
    case paused
    case finished
}
