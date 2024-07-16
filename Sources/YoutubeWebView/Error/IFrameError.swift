//
//  IFrameError.swift
//  
//
//  Created by Goston Wu on 16/7/2024.
//

import Foundation

public enum IFrameError: Error {
    case url
    case callBack
    case invalidParameters
    case htmlFive
    case notEmbeddable
    case videoNotFound
    case unknown(any Error)
    
    init(code: String) {
        switch code {
        case "2":
            self = .invalidParameters
        case "5":
            self = .htmlFive
        case "100":
            self = .videoNotFound
        case "101":
            self = .notEmbeddable
        case "105":
            self = .videoNotFound
        case "150":
            self = .notEmbeddable
        default:
            self = .url
        }
    }
    
    init(error: Error) {
        self = .unknown(error)
    }
}
