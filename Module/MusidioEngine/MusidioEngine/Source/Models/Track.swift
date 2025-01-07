//
//  Track.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/10/22.
//

import AppKit

public struct Artwork: Codable {
    private var data: Data?
    private var url: URL?
    private var defaultArtwork: NSImage? {
        guard let data = Constants.Icons.artwork.image?.tiffRepresentation else {
            return nil
        }
        return NSImage(data: data)
    }
    
    public init(data: Data? = nil, url: URL? = nil) {
        self.data = data
        self.url = url
    }
    
    public func getImage(completion: @escaping (NSImage?) -> Void) {
        if let data = data { // If artwork is initialized with Data...
            completion(NSImage(data: data))
        }
        else if let url = url { // If artwork is initialized with URL...
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(defaultArtwork)
                        return
                    }
                    completion(NSImage(data: data))
                }
            }.resume()
        }
        else { // Fallback if both data and url are nil when artwork is initialized...
            //completion(defaultArtwork)
        }
    }
}

public struct Track: Codable {
    public var name: String? = "Musidio"
    public var artist: String?
    public var album: String?
    public var artwork: Artwork?
    public var totalSeconds: Double?
    public var deeplinkURL: URL?
    
    public init(name: String? = nil, artist: String? = nil, album: String? = nil, artwork: Artwork? = nil, totalSeconds: Double? = nil, deeplinkURL: URL? = nil) {
        self.name = name
        self.artist = artist
        self.album = album
        self.artwork = artwork
        self.totalSeconds = totalSeconds
        self.deeplinkURL = deeplinkURL
    }
}
