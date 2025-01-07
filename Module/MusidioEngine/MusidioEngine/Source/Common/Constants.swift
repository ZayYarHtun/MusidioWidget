//
//  Constants.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/9/22.
//

import AppKit

struct Constants {
    struct NotificationName {
        static let spotify = "com.spotify.client.PlaybackStateChanged"
        static let appleMusic = "com.apple.iTunes.playerInfo"
    }
    
    enum Icons: String {
        case artwork = "ic_artwork"
        
        var image: NSImage? {
            let bundle = Bundle.init(identifier: "com.mobdio.MusidioEngine")
            return bundle?.image(forResource: self.rawValue)
        }
        
        var path: URL? {
            let fileManager = FileManager.default
            guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
            let url = cacheDirectory.appendingPathComponent("\(self.rawValue).png")
            let path = url.path
            if !fileManager.fileExists(atPath: path) {
                guard let image = image, let data = image.tiffRepresentation else {return nil}
                fileManager.createFile(atPath: path, contents: data, attributes: nil)
            }
            return url
        }
    }
}
