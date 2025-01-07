//
//  PlayerMetadata.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/11/22.
//

import Foundation

public enum ControlState: Codable {
    case stopped
    case playing
    case paused
}

public struct PlayerData: Codable {
    public var track: Track?
    public var control: ControlState?
    public var vendor: String?
    public var playerBundleId: String?
    
    public init(track: Track? = nil, control: ControlState? = nil, vendor: String? = nil, playerBundleId: String? = nil) {
        self.track = track
        self.control = control
        self.vendor = vendor
        self.playerBundleId = playerBundleId
    }
    
    var isValid: Bool {
        return !(track?.name?.isEmpty ?? true)
    }
    
    static func getLastData(_ playerType: PlayerType) -> PlayerData {
        guard let dict = Storage.get([String : PlayerData].self, key: .lastPlayerData), var lastData = dict[playerType.vendor] else {
            return PlayerData(track: Track(), control: .paused)
        }
        lastData.control = .paused
        return lastData
    }
    
    static func saveLastData(data: PlayerData) {
        guard let vendor = data.vendor else { return }
        
        var dict = Storage.get([String : PlayerData].self, key: .lastPlayerData) ?? [:]
        dict[vendor] = data
        Storage.save(value: dict, key: .lastPlayerData)
    }
    
}

