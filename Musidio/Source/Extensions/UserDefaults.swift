//
//  UserDefaults.swift
//  Musidio
//
//  Created by Zay Yar Htun on 6/2/22.
//

import Foundation

extension UserDefaults {
    enum Key {
        // MARK: - UI Settings
        static let isAutoStart = "isAutoStart"
        static let playerType = "playerType"
        static let hideControls = "hideControls"
        static let lockPosition = "lockPosition"
        static let playerSize = "playerSize"
        static let showOnAllDesktops = "showOnAllDesktops"
        static let autoDepthControl = "autoDepthControl"
    }
}
