//
//  ViewController.swift
//  Musidio
//
//  Created by Zay Yar Htun on 4/26/22.
//

import Cocoa
import Settings
import MusidioEngine
import Combine

class GeneralVC: NSViewController, SettingsPane {
    @IBOutlet weak var btnStartAtLogin: NSButton!
    @IBOutlet weak var btnPlayer: NSPopUpButton!
    @IBOutlet weak var btnHideControl: NSButton!
    @IBOutlet weak var btnLockPosition: NSButton!
    @IBOutlet weak var btnShowOnAllDesktops: NSButton!
    @IBOutlet weak var btnAutoDepthControl: NSButton!
    @IBOutlet weak var btnWidgetSize: NSPopUpButton!
    
    private var disposeBag = Set<AnyCancellable>()
    
    let paneIdentifier: Settings.PaneIdentifier = Settings.PaneIdentifier.general
    let paneTitle: String = "General"

    var toolbarItemIcon: NSImage {
      if #available(macOS 11.0, *) {
          return NSImage(systemSymbolName: "switch.2", accessibilityDescription: "GeneralTabIcon")!
      } else {
        // Fallback on earlier versions
        return NSImage(named: NSImage.preferencesGeneralName)!
      }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        setupPlayerTypes()
        btnStartAtLogin.state = SettingPreferences.isAutoStart ? .on : .off
        btnPlayer.selectItem(withTitle: SettingPreferences.playerType.vendor)
        btnHideControl.state = SettingPreferences.hideControls ? .on : .off
        btnLockPosition.state = SettingPreferences.lockPosition ? .on : .off
        btnShowOnAllDesktops.state = SettingPreferences.showOnAllDesktops ? .on : .off
        btnAutoDepthControl.state = SettingPreferences.autoDepthControl ? .on : .off
        btnWidgetSize.selectItem(withTitle: SettingPreferences.playerSize.rawValue)
    }
    
    private func setupPlayerTypes() {
        let playerList = PlayerManager.shared.getPlayerList()
        for player in playerList {
            btnPlayer.addItem(withTitle: player.vendor)
        }
    }
    
    // MARK: - Actions
    @IBAction func btnStartAtLoginTapped(_ sender: NSButton) {
        SettingPreferences.isAutoStart = sender.state == .on
    }
    
    @IBAction func btnPlayerTapped(_ sender: NSMenuItem) {
        let playerType = PlayerManager.shared.getPlayerType(forVendor: sender.title)
        SettingPreferences.playerType = playerType
    }
    
    @IBAction func btnHideControlTapped(_ sender: NSButton) {
        SettingPreferences.hideControls = sender.state == .on
    }
    
    @IBAction func btnLockPositionTapped(_ sender: NSButton) {
        SettingPreferences.lockPosition = sender.state == .on
    }
    
    @IBAction func btnShowOnAllDesktopsTappped(_ sender: NSButton) {
        SettingPreferences.showOnAllDesktops = sender.state == .on
    }
    
    @IBAction func btnAutoDepthControlTapped(_ sender: NSButton) {
        SettingPreferences.autoDepthControl = sender.state == .on
    }
    
    @IBAction func btnPlayerSizeChanged(_ sender: NSMenuItem) {
        SettingPreferences.playerSize = PlayerSize.init(rawValue: sender.title) ?? .Fit
    }
    
}

