//
//  Bundle.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/27/22.
//
import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
