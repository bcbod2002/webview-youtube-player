//
//  PlayerError.swift
//
//
//  Created by Goston Wu on 29/6/2024.
//

import Foundation

public enum PlayerError: Error {
    case parameter
    case html
    case source
    case url
    case unknown(any Error)
}
