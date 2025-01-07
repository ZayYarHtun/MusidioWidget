//
//  Utility.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/31/22.
//

import Foundation
import ServiceManagement

class Utility {
    static let shared = Utility()
    
    private init() {}
    
    func isAutoStart(_ value: Bool) {
        let helperBundleId = (Bundle.main.bundleIdentifier ?? "") + "Helper"
        SMLoginItemSetEnabled(helperBundleId as CFString, value)
    }
    
}
