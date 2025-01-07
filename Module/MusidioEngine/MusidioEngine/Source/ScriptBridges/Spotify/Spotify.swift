//
//  Spotify.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/9/22.
//

import AppKit
import ScriptingBridge

@objc public protocol SBObjectProtocol: NSObjectProtocol {
    func get() -> Any!
}

@objc public protocol SBApplicationProtocol: SBObjectProtocol {
    func activate()
    var delegate: SBApplicationDelegate! { get set }
    @objc optional var isRunning: Bool { get }
}

// MARK: SpotifyEPlS
@objc public enum SpotifyEPlS : AEKeyword {
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
        }
    }
}

// MARK: SpotifyApplication
@objc public protocol SpotifyApplication: SBApplicationProtocol {
    @objc optional var currentTrack: SpotifyTrack { get }
    @objc optional var playerState: SpotifyEPlS { get }
    @objc optional var playerPosition: Double { get } // current playing track position in seconds
    @objc optional var repeating: Bool { get }
    @objc optional func nextTrack()
    @objc optional func previousTrack()
    @objc optional func playpause()
    @objc optional func pause()
    @objc optional func play()
    @objc optional func setPlayerPosition(_ playerPosition: Double)
    @objc optional var name: String { get }
    @objc optional var frontmost: Bool { get }
    @objc optional var version: String { get }
}
extension SBApplication: SpotifyApplication {}

// MARK: SpotifyTrack
@objc public protocol SpotifyTrack: SBObjectProtocol {
    @objc optional var artist: String { get }
    @objc optional var album: String { get }
    @objc optional var duration: Int { get }
    @objc optional func id() -> String
    @objc optional var name: String { get }
    @objc optional var artworkUrl: String { get }
    @objc optional var artwork: NSImage { get }
    @objc optional var albumArtist: String { get }
    @objc optional var spotifyUrl: String { get }
    @objc optional func setSpotifyUrl(_ spotifyUrl: String!)
}
extension SBObject: SpotifyTrack {}

// MARK: MockSpotifyApplication
public class MockSpotifyApplication: NSObject, SpotifyApplication {
    
    public enum TestResult: String {
        case nextTrack = "nextTrack"
        case previousTrack = "previousTrack"
        case playPause = "playPause"
        case playerPosition = "1000.0"
        case none = ""
    }
    
    public var result: TestResult = .none
    public func activate() { print("Activate Spotify App") }
    public var delegate: SBApplicationDelegate!
    
    public func get() -> Any! {
        return nil
    }
    
    public func nextTrack() {
        result = .nextTrack
    }
    
    public func previousTrack() {
        result = .previousTrack
    }
   
    public func playpause() {
        result = .playPause
    }
    
    public func setPlayerPosition(_ playerPosition: Double) {
        result = TestResult.init(rawValue: "\(playerPosition)") ?? .none
    }
    
    public var playerPosition: Double {
        return 1000
    }
    
    public var isRunning: Bool {
        return false
    }
}

