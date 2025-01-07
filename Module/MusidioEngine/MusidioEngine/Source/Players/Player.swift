//
//  PlayerService.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/9/22.
//

import Foundation
import Combine

public protocol PlayerType {
    var vendor: String { get }
    var playerBundleId: String { get }
}

public enum FreePlayer: String, PlayerType, CaseIterable {
    
    case spotify = "Spotify"
    case appleMusic = "Apple Music"
    
    public var vendor: String {
        return self.rawValue
    }
    
    public var playerBundleId: String {
        switch self {
        case .spotify:
            return "com.spotify.client"
        case .appleMusic:
            return "com.apple.Music"
        }
    }
    
}

public enum PlayerState {
    case state(PlayerData)
    case none
}

public protocol Player {
    var playerState: DriverPublisher<PlayerState> { get }
    var positionState: DriverPublisher<Double> { get }
    func next()
    func previous()
    func togglePlay()
    func setPosition(postion: Double)
}
