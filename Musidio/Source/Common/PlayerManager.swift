//
//  PlayerManager.swift
//  Musidio
//
//  Created by Zay Yar Htun on 8/20/23.
//

import Foundation
import MusidioEngine

class PlayerManager {
    static let shared = PlayerManager()
    
    private init() {}
    
    func getPlayerType(forVendor: String) -> PlayerType {
        return FreePlayer.init(rawValue: forVendor) ?? FreePlayer.spotify
    }
    
    func createPlayer(playerType: any PlayerType) -> Player? {
        switch playerType {
        case FreePlayer.spotify, FreePlayer.appleMusic:
            return PlayerConcreteFactory.createPlayer(playerType)
        default:
            return nil
        }
    }
    
    func getPlayerList() -> [PlayerType] {
        var list = Array<PlayerType>()
        list.append(contentsOf: FreePlayer.allCases)
        return list
    }
}
