//
//  PlayerFactory.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/9/22.
//

import Foundation
import ScriptingBridge

public protocol PlayerFactory {
    static func createPlayer(_ playerType: PlayerType) -> Player?
}

public struct PlayerConcreteFactory: PlayerFactory {
    public static func createPlayer(_ playerType: PlayerType) -> Player? {
        switch playerType {
        case FreePlayer.spotify:
            return SpotifyPlayer(application: isTestMode ? MockSpotifyApplication() : SBApplication(bundleIdentifier: playerType.playerBundleId))
        case FreePlayer.appleMusic:
            return AppleMusicPlayer(application: SBApplication(bundleIdentifier: playerType.playerBundleId))
        default:
            return nil
        }
    }
}
