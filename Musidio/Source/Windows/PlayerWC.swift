//
//  SpotifyWindowController.swift
//  Musidio
//
//  Created by Zay Yar Htun on 4/26/22.
//

import Cocoa
import MusidioEngine

class PlayerWC: NSWindowController {
    private var currentPlayerType: (any PlayerType)?
    
    // MARK: - Life Cycle
    override func windowDidLoad() {
        super.windowDidLoad()
        setup()
        observeSettingPreferences()
    }
    
    // MARK: - Setup
    private func setup() {
        window?.isMovable = !SettingPreferences.lockPosition
        window?.collectionBehavior = SettingPreferences.showOnAllDesktops ? [.canJoinAllSpaces, .fullScreenAuxiliary] : [.fullScreenAuxiliary]

        window?.backgroundColor = .clear
        window?.isMovableByWindowBackground = true
        window?.styleMask = .borderless
        
        #if DEBUG
        window?.level = .statusBar
        #else
        window?.level = .init(-1)
        #endif
        
        setupPlayerVC(SettingPreferences.playerType)
    }
    
    private func setupPlayerVC(_ playerType: any PlayerType) {
        if let window = window {
            let player = PlayerManager.shared.createPlayer(playerType: playerType)
            let vc = PlayerVC.createVC(player: player)
            currentPlayerType = playerType
            window.contentViewController = vc
            vc?.hideControls = SettingPreferences.hideControls
            vc?.autoDepthControl = SettingPreferences.autoDepthControl
            vc?.setPlayerSize(SettingPreferences.playerSize.getSize(), animate: false)
         }
    }
    
    // MARK: - Private API
    private func observeSettingPreferences() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSetting(_:)),
            name: .settingPreferences,
            object: nil
        )
    }
    
    @objc func updateSetting(_ notificaiton: NSNotification) {
        guard let vc = window?.contentViewController as? PlayerVC else { return }
        
        if let hideControls = notificaiton.userInfo?[UserDefaults.Key.hideControls] as? Bool {
            vc.hideControls = hideControls
        }
        
        if let playerType = notificaiton.userInfo?[UserDefaults.Key.playerType] as? any PlayerType {
            guard currentPlayerType?.vendor != playerType.vendor else { return }
            setupPlayerVC(playerType)
        }
        
        if let lockPosition = notificaiton.userInfo?[UserDefaults.Key.lockPosition] as? Bool {
            vc.view.window?.isMovable = !lockPosition
        }
        
        if let showOnAllDesktops = notificaiton.userInfo?[UserDefaults.Key.showOnAllDesktops] as? Bool {
            vc.view.window?.collectionBehavior = showOnAllDesktops ? [.canJoinAllSpaces, .fullScreenAuxiliary] : [.fullScreenAuxiliary]
        }
        
        if let autoDepthControl = notificaiton.userInfo?[UserDefaults.Key.autoDepthControl] as? Bool {
            vc.autoDepthControl = autoDepthControl
        }
        
        if let playerSize = notificaiton.userInfo?[UserDefaults.Key.playerSize] as? PlayerSize {
            vc.setPlayerSize(playerSize.getSize(), animate: true)
        }
    }
    
}
