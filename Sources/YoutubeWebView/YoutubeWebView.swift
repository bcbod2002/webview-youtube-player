//
//  SwiftUIView.swift
//  
//
//  Created by Goston Wu on 13/8/2024.
//

import SwiftUI

private extension YoutubeWebView {
    struct Construction {
        let videoURLs: [URL?]
        let videoIDs: [String]
        let autoPlay: Bool
        let inlineMedia: Bool
        let showControl: Bool
        let keepLoop: Bool
    }
    
    final private class Listener {
        var arrangeError: ((any Error) -> Void)?
        var execution: (() -> PlayerCommand)?
    }
}

public struct YoutubeWebView: UIViewRepresentable {
    
    private let witness = YoutubeWitness()
    private let listener = Listener()
    private let contruction: Construction
    
    public init(
        videoURLs: [URL?],
        autoPlay: Bool = false,
        inlineMedia: Bool = true,
        showControl: Bool = true,
        keepLoop: Bool = false
    ) {
        contruction = Construction(
            videoURLs: videoURLs,
            videoIDs: [],
            autoPlay: autoPlay,
            inlineMedia: inlineMedia,
            showControl: showControl,
            keepLoop: keepLoop
        )
    }
    
    public init(
        videoIDs: [String],
        autoPlay: Bool = false,
        inlineMedia: Bool = true,
        showControl: Bool = true,
        keepLoop: Bool = false
    ) {
        contruction = Construction(
            videoURLs: [],
            videoIDs: videoIDs,
            autoPlay: autoPlay,
            inlineMedia: inlineMedia,
            showControl: showControl,
            keepLoop: keepLoop
        )
    }
    
    public func makeUIView(context: Context) -> YoutubeWebUIView {
        YoutubeWebUIView(frame: .zero)
    }

    public func updateUIView(_ uiView: YoutubeWebUIView, context: Context) {
        uiView.add(witness)
        do {
            if !contruction.videoURLs.isEmpty {
                try uiView.arrange(
                    contruction.videoURLs,
                    autoPlay: contruction.autoPlay,
                    inlineMedia: contruction.inlineMedia,
                    showControl: contruction.showControl,
                    keepLoop: contruction.keepLoop
                )
            } else if !contruction.videoIDs.isEmpty {
                try uiView.arrange(
                    videoIDs: contruction.videoIDs,
                    autoPlay: contruction.autoPlay,
                    inlineMedia: contruction.inlineMedia,
                    showControl: contruction.showControl,
                    keepLoop: contruction.keepLoop
                )
            } else {
                throw PlayerError.source
            }
        } catch {
            listener.arrangeError?(error)
        }
    }
}

extension YoutubeWebView {
    public func onReady(incident: @escaping (String) -> Void) -> Self {
        witness.onReadys.append(incident)
        return self
    }
    
    public func onStateChange(incident: @escaping (String) -> Void) -> Self {
        witness.onStateChanges.append(incident)
        return self
    }
    
    public func onQualityChange(incident: @escaping (String) -> Void) -> Self {
        witness.onQualityChanges.append(incident)
        return self
    }
    
    public func onError(incident: @escaping (IFrameError) -> Void) -> Self {
        witness.onErrors.append(incident)
        return self
    }
}

extension YoutubeWebView {
    public func onArrange(error: @escaping (any Error) -> Void) -> Self {
        listener.arrangeError = error
        return self
    }
}

extension YoutubeWebView {
    public func execute(command: @escaping () -> PlayerCommand) -> Self {
        listener.execution = command
        return self
    }
}
