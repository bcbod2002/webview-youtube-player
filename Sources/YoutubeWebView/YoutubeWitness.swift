//
//  YoutubeWitness.swift
//  
//
//  Created by Goston Wu on 11/7/2024.
//

import Foundation

final public class YoutubeWitness {
    
    var onReadys: ContiguousArray<(String) -> Void>
    var onStateChanges: ContiguousArray<(String) -> Void>
    var onQualityChanges: ContiguousArray<(String) -> Void>
    var onErrors: ContiguousArray<(IFrameError) -> Void>
    
    public init() {
        self.onReadys = ContiguousArray<(String) -> Void>()
        self.onStateChanges = ContiguousArray<(String) -> Void>()
        self.onQualityChanges = ContiguousArray<(String) -> Void>()
        self.onErrors = ContiguousArray<(IFrameError) -> Void>()
    }
    
    @discardableResult
    public func onReady(incident: @escaping (String) -> Void) -> Self {
        onReadys.append(incident)
        return self
    }
    
    @discardableResult
    public func onStateChange(incident: @escaping (String) -> Void) -> Self {
        onStateChanges.append(incident)
        return self
    }
    
    @discardableResult
    public func onQualityChange(incident: @escaping (String) -> Void) -> Self {
        onQualityChanges.append(incident)
        return self
    }
    
    @discardableResult
    public func onError(incident: @escaping (IFrameError) -> Void) -> Self {
        onErrors.append(incident)
        return self
    }
}
