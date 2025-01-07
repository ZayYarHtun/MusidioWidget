//
//  MainWindowController.swift
//  Musidio
//
//  Created by Zay Yar Htun on 4/26/22.
//

import Cocoa
import Settings

class PrefWC {
    var preferenceWindowController: SettingsWindowController = {
        var panes: [SettingsPane] = []
        let generalVC = NSStoryboard.generalVC() as? SettingsPane
        let aboutVC = NSStoryboard.aboutVC() as? SettingsPane
        if let _ = generalVC, let _ = aboutVC {
            panes.append(generalVC!)
            panes.append(aboutVC!)
        }

        return SettingsWindowController(panes: panes)
    }()
    
}


