import Foundation
import UIKit
import WebKit

public protocol VideoParceable {
    init(_ url: URL)
    init(_ videoID: String)
}

public class YoutubeWebView: UIView {
    
    private static let baseURL = "https://www.youtube.com/watch?v="
    
    private let webView: WKWebView = WKWebView()
    private var videoIDs: ContiguousArray<String> = []
    private var autoPlay = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        addSubview(webView)
        constraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubview(webView)
        constraint()
    }
    
    private func configure() {
        webView.navigationDelegate = self
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.userContentController.add(self, name: "onReady")
        webView.configuration.userContentController.add(self, name: "onStateChange")
    }
    
    private func constraint() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func arrange(_ videoURLs: [URL?], autoPlay: Bool = false) throws {
    public func add(_ witness: YoutubeWitness) {
        witnesses.append(witness)
    }
        let urls = videoURLs.compactMap { $0 }
        let preparation = PlayerPreparation()
        videoIDs = try ContiguousArray(unsafeUninitializedCapacity: urls.count) { buffer, initializedCount in
            for index in urls.indices {
                buffer[index] = try preparation.videoID(from: urls[index])
            }
            initializedCount = videoURLs.count
        }
        guard let videoID = videoIDs.first else { throw PlayerError.url }
        let html = try preparation.prepareHTML(with: videoID, size: bounds.size, autoPlay: autoPlay)
        self.autoPlay = autoPlay
        webView.loadHTMLString(html, baseURL: urls.first)
    }
    
    public func arrange(videoIDs: [String], autoPlay: Bool = false) throws {
        let preparation = PlayerPreparation()
        self.videoIDs = ContiguousArray(videoIDs)
        guard let videoID = videoIDs.first else { throw PlayerError.url }
        let html = try preparation.prepareHTML(with: videoID, size: bounds.size, autoPlay: autoPlay)
        self.autoPlay = autoPlay
        webView.loadHTMLString(html, baseURL: URL(string: "\(Self.baseURL)\(videoID)"))
    }
    
    public func execute(_ command: consuming PleyerCommand) {
        switch consume command {
        case .play:
            webView.evaluateJavaScript("play()")
        case .stop:
            webView.evaluateJavaScript("stop()")
        case .pause:
            webView.evaluateJavaScript("pause()")
        case .forward(let value):
            webView.evaluateJavaScript("forward(\(value))")
        }
    }
}

extension YoutubeWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("prepareYoutubePlayer()")
    }
}

extension YoutubeWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "onReady" where autoPlay:
            webView.configuration.allowsInlineMediaPlayback = true
            execute(.play)
            webView.configuration.allowsInlineMediaPlayback = false
            witnessOnReady(with: message.body)
        case "onStateChange":
            witnessOnStateChange(with: message.body)
        case "onQualityChange":
            witnessOnQualityChange(with: message.body)
        case "onError":
            witnessOnError(with: message.body)
        default:
            break
        }
    }
    
    private func witnessOnReady(with body: Any) {
        guard let body = body as? [String: String], let data = body["data"] else { return }
        witnesses.forEach { witness in
            witness.onReadys.forEach { closure in
                closure(data)
            }
        }
    }
    
    private func witnessOnStateChange(with body: Any) {
        guard let body = body as? [String: String], let data = body["data"] else { return }
        witnesses.forEach { witness in
            witness.onStateChanges.forEach { closure in
                closure(data)
            }
        }
    }
    
    private func witnessOnQualityChange(with body: Any) {
        guard let body = body as? [String: String], let data = body["data"] else { return }
        witnesses.forEach { witness in
            witness.onQualityChanges.forEach { closure in
                closure(data)
            }
        }
    }
    
    private func witnessOnError(with body: Any) {
        guard let body = body as? [String: String], let data = body["data"] else { return }
        witnesses.forEach { witness in
            witness.onErrors.forEach { closure in
                closure(data)
            }
        }
    }
}
