//
//  AppUpdateController.swift
//  Musidio
//
//  Created by Zay Yar Htun on 11/21/22.
//

import Foundation
import Sparkle

class AppUpdateController {
    static let shared = AppUpdateController()
    private var sparkleController: SPUStandardUpdaterController!
    
    // MARK: - Initializers
    private init() {
        sparkleController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    // MARK: - Public API
    func checkForUpdate(_ sender: Any) {
        sparkleController.checkForUpdates(sender)
    }
}
