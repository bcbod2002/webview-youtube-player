import Foundation
import UIKit
import WebKit

public protocol VideoParceable {
    init(_ url: URL)
    init(_ videoID: String)
}

public class YoutubeWebView: UIView {
    private let webView: WKWebView = WKWebView()
    private var videoIDs: ContiguousArray<String> = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        webView.navigationDelegate = self
        addSubview(webView)
        constraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        webView.navigationDelegate = self
        addSubview(webView)
        constraint()
    }
    
    private func constraint() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func setURL(_ url: URL) throws {
        let preparation = PlayerPreparation()
        let videoID = try preparation.videoID(from: url)
//        videoIDs = [consume videoID]
        let html = try preparation.prepareHTML(with: videoID, size: bounds.size)
        webView.loadHTMLString(html, baseURL: url)
    }
    
    public func setVideoID(_ id: consuming String) {
        videoIDs = [consume id]
    }
    
    func setVideoURLs(_ urls: consuming [URL]) throws {
        let preparation = PlayerPreparation()
        videoIDs = try ContiguousArray(unsafeUninitializedCapacity: urls.count) { buffer, initializedCount in
            for index in urls.indices {
                buffer[index] = try preparation.videoID(from: urls[index])
            }
            initializedCount = urls.count
        }
    }
    
    public func execute(_ command: consuming PleyerCommand) {
        switch consume command {
        case .play:
            webView.evaluateJavaScript("play()")
        case .stop:
            webView.evaluateJavaScript("stop()")
        case .pause:
            webView.evaluateJavaScript("pause()")
        case .forward(let value) where value > 0:
            webView.evaluateJavaScript("forward(\(value))")
        case .forward(let value):
            webView.evaluateJavaScript("backward(\(value))")
        }
    }
}

extension YoutubeWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("prepareYoutubePlayer()")
    }
}
