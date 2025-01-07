//
//  AppleMusic.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 7/12/22.
//

import AppKit
import ScriptingBridge

// MARK: iTunesEPlS
@objc public enum iTunesEPlS : AEKeyword {
    case stopped = 0x6b505353 // kPSS
    case playing = 0x6b505350 // kPSP
    case paused = 0x6b505370 // kPSp
    
    func mapToControlState() -> ControlState {
        switch self {
        case .stopped:
            return ControlState.stopped
        case .playing:
            return ControlState.playing
        case .paused:
            return ControlState.paused
        default: return ControlState.stopped
        }
    }
}

// MARK: iTunesApplication
@objc public protocol iTunesApplication: SBApplicationProtocol {
    @objc optional var name: String { get }
    @objc optional var playerPosition: Double { get } // current playing track position in seconds
    @objc optional var playerState: iTunesEPlS { get }
    @objc optional var version: String { get }
    @objc optional func run()
    @objc optional func quit()
    @objc optional var currentTrack: iTunesTrack { get }
    @objc optional func nextTrack()
    @objc optional func pause()
    @objc optional func playpause()
    @objc optional func previousTrack()
    @objc optional func resume()
    @objc optional func stop()
    @objc optional func setPlayerPosition(_ playerPosition: Double)
}
extension SBApplication: iTunesApplication {}

// MARK: iTunesItem
@objc public protocol iTunesItem: SBObjectProtocol {
    @objc optional func id() -> Int
    @objc optional var name: String { get }
}
extension SBObject: iTunesItem {}

// MARK: iTunesArtwork
@objc public protocol iTunesArtwork: iTunesItem {
    @objc optional var data: NSImage { get }
}
extension SBObject: iTunesArtwork {}

// MARK: iTunesTrack
@objc public protocol iTunesTrack: iTunesItem {
    @objc optional func artworks() -> SBElementArray
    @objc optional var album: String { get }
    @objc optional var albumArtist: String { get }
    @objc optional var artist: String { get }
    @objc optional var duration: Double { get }
}
extension SBObject: iTunesTrack {}
