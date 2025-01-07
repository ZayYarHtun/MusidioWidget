//
//  Preferences.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/31/22.
//

import Foundation
import MusidioEngine

enum SettingPreferences {
    // MARK: - UI Settings
    static var isAutoStart: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.isAutoStart)
            Utility.shared.isAutoStart(newValue)
        }
        get {
            guard let value = UserDefaults.standard.value(forKey: UserDefaults.Key.isAutoStart) as? Bool else {
                return false
            }
            return value
        }
    }
    
    static var playerType: PlayerType {
        set {
            UserDefaults.standard.set(newValue.vendor, forKey: UserDefaults.Key.playerType)
            NotificationCenter.default.post(
                name: .settingPreferences,
                object: nil,
                userInfo: [UserDefaults.Key.playerType : newValue]
            )
        }
        get {
            guard let vendor = UserDefaults.standard.value(forKey: UserDefaults.Key.playerType) as? String else {
                return FreePlayer.spotify
            }
            
            let playerType = PlayerManager.shared.getPlayerType(forVendor: vendor)
            return playerType
        }
    }
    
    static var hideControls: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.hideControls)
            NotificationCenter.default.post(
                name: .settingPreferences,
                object: nil,
                userInfo: [UserDefaults.Key.hideControls : newValue]
            )
        }
        get {
            guard let value = UserDefaults.standard.value(forKey: UserDefaults.Key.hideControls) as? Bool else {
                return false
            }
            return value
        }
    }
    
    static var lockPosition: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.lockPosition)
            NotificationCenter.default.post(
                name: .settingPreferences,
                object: nil,
                userInfo: [UserDefaults.Key.lockPosition : newValue]
            )
        }
        get {
            guard let value = UserDefaults.standard.value(forKey: UserDefaults.Key.lockPosition) as? Bool else {
                return true
            }
            return value
        }
    }
    
    static var showOnAllDesktops: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.showOnAllDesktops)
            NotificationCenter.default.post(
                name: .settingPreferences,
                object: nil,
                userInfo: [UserDefaults.Key.showOnAllDesktops : newValue]
            )
        }
        get {
            guard let value = UserDefaults.standard.value(forKey: UserDefaults.Key.showOnAllDesktops) as? Bool else {
                return true
            }
            return value
        }
    }
    
    static var playerSize: PlayerSize {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaults.Key.playerSize)
            NotificationCenter.default.post(
                name: .settingPreferences,
                object: nil,
                userInfo: [UserDefaults.Key.playerSize : newValue]
            )
        }
        get {
            guard let str = UserDefaults.standard.value(forKey: UserDefaults.Key.playerSize) as? String, let value = PlayerSize.init(rawValue: str) else {
                return PlayerSize.Fit
            }
            return value
        }
    }
    
    static var autoDepthControl: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.autoDepthControl)
            NotificationCenter.default.post(
                name: .settingPreferences,
                object: nil,
                userInfo: [UserDefaults.Key.autoDepthControl : newValue]
            )
        }
        get {
            guard let value = UserDefaults.standard.value(forKey: UserDefaults.Key.autoDepthControl) as? Bool else {
                return true
            }
            return value
        }
    }
    
}
