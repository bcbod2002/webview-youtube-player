//
//  PlayerPreparation.swift
//
//
//  Created by Goston Wu on 29/6/2024.
//

// Reference for parameters in Youtube player
// https://developers.google.com/youtube/iframe_api_reference

import Foundation

public struct PlayerPreparation {
    
    private let jsonEncoder: JSONEncoder
    
    public init() {
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.outputFormatting = .prettyPrinted
    }
    
    public func videoID(from url: URL) throws -> String {
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: true) else { throw PlayerError.url }
        let path = component.path
        if path.contains("embed") {
            return path.components(separatedBy: "/").last ?? ""
        } else if path.contains("watch") {
            return component.queryItems?.first(where: { $0.name == "v" })?.value ?? ""
        } else {
            throw PlayerError.url
        }
    }
    
    public func prepareHTML(with videoID: String, size: CGSize) throws -> String {
        let templateURL = Bundle.module.url(forResource: "YoutubeIframe", withExtension: "html")
        guard let templateURL else { throw PlayerError.html }
        do {
            let data = try Data(contentsOf: templateURL)
            let htmlTemplate = String(data: data, encoding: .utf8)
            guard let htmlTemplate else { throw PlayerError.html }
            let parameters = PlayerParameters(size: size, videoID: videoID)
        
            let encodedData = try jsonEncoder.encode(consume parameters)
            let encodedString = String(data: consume encodedData, encoding: .utf8)
            
            guard let encodedString else { throw PlayerError.parameter }
            return String(format: consume htmlTemplate, consume encodedString)
        } catch {
            throw PlayerError.unknown(error)
        }
    }
}
