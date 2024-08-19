# WebView-Youtube-Player

## Overview

It's a simple Youtube player that you can use it straight away.
But haven't tested in the table view / collection view / lazy grid.

### Swift Package Manager

Add the following line in your Package.swift

```swift
.package("https://github.com/bcbod2002/webview-youtube-player", branch: "master")
```

Add `webview-youtube-player` to target's dependencies.

```swift
.target(
    name: "TargetName",
    dependencies: ["YoutubeWebView"]
)
```

## Usage

### UIKit

```swift
import YoutubeWebView

final class ViewController: UIViewController {

    @IBOutlet weak var playerView: YoutubeWebUIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let witness = YoutubeWitness()
            .onReady { incident in
                // Observe player on ready incident
            }
            .onStateChange { incident in
                // Observe player state change incident
            }
            .onQualityChange { incident in
                // Observe player quality change 1st incident
            }
            .onQualityChange { incident in
                // Observe player quality change 2nd incident
            }

        playerView.add(witness)

        // If you want to play the video automatically
        try? playerView.arrange(videoIDs: ["drCnFueS4og"], autoPlay: true)

        // If you want to play the video by yout control
        try? playerView.arrange(videoIDs: ["drCnFueS4og"])
        playerView.execute(.play)
    }
}
```

### SwiftUI

```swift
import YoutubeWebView

struct ContentView: View {
    var body: some View {
        YoutubeWebView(videoIDs: ["drCnFueS4og"], autoPlay: true)
                .onReady { incident in
                    // Observe player on ready incident
                }
                .onStateChange { incident in
                    // Observe player state change incident
                }
                .onQualityChange { incident in
                    // Observe player quality change 1st incident
                }
                .onQualityChange { incident in
                    // Observe player quality change 2nd incident
                }
    }
}
```

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
This code is distributed unter the terms and conditions of the MIT license
