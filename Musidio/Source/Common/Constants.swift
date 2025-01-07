//
//  Constants.swift
//  Musidio
//
//  Created by Zay Yar Htun on 6/2/22.
//

import AppKit

struct Constants {
    enum Icons: String {
        case prev = "ic_prev"
        case prevActive = "ic_prev_active"
        case next = "ic_next"
        case nextActive = "ic_next_active"
        case play = "ic_play"
        case pause = "ic_pause"
        
        var image: NSImage? {
            return NSImage(named: self.rawValue)
        }
        
    }
    
    struct Player {
        static let fallbackPosition = NSPoint(x: 40.0, y: 40.0)
    }
}
