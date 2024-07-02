//
//  PlayerParameters.swift
//  
//
//  Created by Goston Wu on 29/6/2024.
//

import Foundation


struct PlayerVars: Encodable {
    let playerInline = 1
}

struct PlayerEvents: Encodable {
    let onReady = "onReady"
    let onStateChange = "onStateChange"
    let onPlaybackQualityChange = "onQualityChange"
    let onError = "onError"
}


struct PlayerParameters: Encodable {
    let height: CGFloat
    let width: CGFloat
    let videoID: String
    let playerVars: PlayerVars = PlayerVars()
    let events: PlayerEvents = PlayerEvents()
    
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case videoID = "videoId"
        case playerVars
        case events
    }
    
    init(size: CGSize, videoID: String) {
        self.height = size.height
        self.width = size.width
        self.videoID = videoID
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(height)", forKey: .height)
        try container.encode("\(width)", forKey: .width)
        try container.encode(videoID, forKey: .videoID)
        try container.encode(playerVars, forKey: .playerVars)
        try container.encode(events, forKey: .events)
    }
}
