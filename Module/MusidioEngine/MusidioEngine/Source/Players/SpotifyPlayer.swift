//
//  SpotifyPlayer.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/9/22.
//

import AppKit
import ScriptingBridge
import Combine

public class SpotifyPlayer {
    let spotify: SpotifyApplication
    let position: CurrentValueSubject<Double, Never>
    let state: CurrentValueSubject<PlayerState, Never>
    
    private var positionTimer: Timer?
        
    init?(application: SpotifyApplication?) {
        guard let application = application as? SBApplication else { return nil }
        // Event timeout will be 1 second in ticks.
        application.timeout = 10_000_000

        spotify = application
        let appIsRunning = spotify.isRunning ?? false
        
        state = appIsRunning ? .init(spotify.state) : .init(.state(PlayerData.getLastData(FreePlayer.spotify)))
        position = appIsRunning ? .init(spotify.playerPosition ?? 0.0) : .init(0.0)
        
        if appIsRunning { // Start Position Timer if Spotify is playing
            togglePositionTimer(spotify.isPlaying)
        }
        subscribeAppNotification()
    }
    
    deinit {
        print("deinit spotify player")
        unSubscribeAppNotification()
    }
}

// MARK: - Player Extension
extension SpotifyPlayer: Player {
    public var playerState: DriverPublisher<PlayerState> {
        state.asDriverPublisher()
    }
    
    public var positionState: DriverPublisher<Double> {
        position.asDriverPublisher()
    }
    
    public func next() {
        spotify.nextTrack?()
    }
    
    public func previous() {
        spotify.previousTrack?()
    }
    
    public func togglePlay() {
        guard let isRunning = spotify.isRunning, isRunning else {
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: FreePlayer.spotify.playerBundleId) else { return }
            NSWorkspace.shared.open(url)
            return
        }
        spotify.playpause?()
    }
    
    public func setPosition(postion: Double) {
        spotify.setPlayerPosition?(postion)
    }
        
    private func subscribeAppNotification() {
        DistributedNotificationCenter
            .default()
            .addObserver(
                self,
                selector: #selector(receivedAppNotification(_:)),
                name: Notification.Name(Constants.NotificationName.spotify),
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
            state.send(spotify.state)
            position.send(spotify.playerPosition ?? 0.0)
            togglePositionTimer(spotify.isPlaying)
        case "Stopped":
            state.send(.state(PlayerData.getLastData(FreePlayer.spotify)))
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
            self.position.send(self.spotify.playerPosition ?? 0.0)
        }
    }
}

// MARK: - SpotifyApplication Extension
extension SpotifyApplication {
    fileprivate var state: PlayerState {
        let track = currentTrack?.toTrack()
        let control = controlState
        let playerData = PlayerData(track: track, control: control, vendor: FreePlayer.spotify.vendor, playerBundleId: FreePlayer.spotify.playerBundleId)
        if playerData.isValid {
            PlayerData.saveLastData(data: playerData)
            return .state(playerData)
        } else {
            return .state(PlayerData.getLastData(FreePlayer.spotify))
        }
    }
    
    fileprivate var controlState: ControlState {
        return playerState?.mapToControlState() ?? .stopped
    }
    
    fileprivate var isPlaying: Bool {
        return controlState == .playing
    }
}

// MARK: - SpotifyTrack Extension
extension SpotifyTrack {
    fileprivate func toTrack() -> Track {
        return Track(
            name: name,
            artist: artist,
            artwork: Artwork(url: URL(string: artworkUrl ?? "")),
            totalSeconds: Double(duration ?? 0) / 1000,
            deeplinkURL: URL(string: spotifyUrl ?? "")
        )
    }
}
