//
//  AppleMusicPlayer.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 7/12/22.
//

import AppKit
import ScriptingBridge
import Combine

class AppleMusicPlayer {
    let appleMusic: iTunesApplication
    let position: CurrentValueSubject<Double, Never>
    let state: CurrentValueSubject<PlayerState, Never>
    
    private var positionTimer: Timer?
    
    init?(application: iTunesApplication?) {
        guard let application = application as? SBApplication else { return nil }
        // Event timeout will be 1 second in ticks.
        application.timeout = 10_000_000
        
        appleMusic = application
        let appIsRunning = appleMusic.isRunning ?? false
        
        state = appIsRunning ? .init(appleMusic.state) : .init(.state(PlayerData.getLastData(FreePlayer.appleMusic)))
        position = appIsRunning ? .init(appleMusic.playerPosition ?? 0.0) : .init(0.0)
        
        if appIsRunning { // Start Position Timer if Apple Music is playing
            togglePositionTimer(appleMusic.isPlaying)
        }
        subscribeAppNotification()
    }
    
    deinit {
        print("deinit apple music player")
        unSubscribeAppNotification()
    }
}

// MARK: - Player Extension
extension AppleMusicPlayer: Player {
    public var playerState: DriverPublisher<PlayerState> {
        state.asDriverPublisher()
    }
    
    public var positionState: DriverPublisher<Double> {
        position.asDriverPublisher()
    }
    
    public func next() {
        appleMusic.nextTrack?()
    }
    
    public func previous() {
        appleMusic.previousTrack?()
    }
    
    public func togglePlay() {
        guard let isRunning = appleMusic.isRunning, isRunning else {
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: FreePlayer.appleMusic.playerBundleId) else { return }
            NSWorkspace.shared.open(url)
            return
        }
        appleMusic.playpause?()
    }
    
    public func setPosition(postion: Double) {
        appleMusic.setPlayerPosition?(postion)
    }
    
    private func subscribeAppNotification() {
        DistributedNotificationCenter
            .default()
            .addObserver(
                self,
                selector: #selector(receivedAppNotification(_:)),
                name: Notification.Name(Constants.NotificationName.appleMusic),
                object: nil
            )
    }
    
    private func unSubscribeAppNotification() {
        DistributedNotificationCenter.default().removeObserver(self)
        togglePositionTimer(false)
    }
    
    @objc private func receivedAppNotification(_ obj: NSNotification) {
        guard let playerState = obj.userInfo?["Player State"] as? String else { return }
        switch playerState {
        case "Paused", "Playing":
            state.send(appleMusic.state)
            position.send(appleMusic.playerPosition ?? 0.0)
            togglePositionTimer(appleMusic.isPlaying)
        case "Stopped":
            state.send(.state(PlayerData.getLastData(FreePlayer.appleMusic)))
            togglePositionTimer(false)
        default: break
        }
    }
    
    private func togglePositionTimer(_ start: Bool) {
        if start {
            positionTimer?.invalidate()
            positionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: timerExecution(_:))
        } else {
            positionTimer?.invalidate()
        }
    }
    
    private func timerExecution(_ timer: Timer) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.position.send(self.appleMusic.playerPosition ?? 0.0)
        }
    }
}

// MARK: - iTunesApplication Extension
extension iTunesApplication {
    fileprivate var state: PlayerState {
        let track = currentTrack?.toTrack()
        let control = controlState
        let playerData = PlayerData(track: track, control: control, vendor: FreePlayer.appleMusic.vendor, playerBundleId: FreePlayer.appleMusic.playerBundleId)
        if playerData.isValid {
            PlayerData.saveLastData(data: playerData)
            return .state(playerData)
        } else {
            return .state(PlayerData.getLastData(FreePlayer.appleMusic))
        }
    }
    
    fileprivate var controlState: ControlState {
        return playerState?.mapToControlState() ?? .stopped
    }
    
    fileprivate var isPlaying: Bool {
        return controlState == .playing
    }
}

// MARK: - iTunesTrack Extension
extension iTunesTrack {
    fileprivate func toTrack() -> Track {
        let artwork = artworks?().firstObject as? iTunesArtwork
        return Track(
            name: name,
            artist: artist,
            artwork: Artwork(data: artwork?.data?.tiffRepresentation),
            totalSeconds: Double(duration ?? 0),
            deeplinkURL: URL(string: "")
        )
    }
}
