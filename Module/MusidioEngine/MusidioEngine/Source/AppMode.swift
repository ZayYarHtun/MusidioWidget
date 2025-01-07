//
//  AppMode.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/25/22.
//

import Foundation

enum AppMode: String {
    case debug
    case test
    case release
}

#if DEBUG
let appMode: AppMode = .debug
#elseif TEST
let appMode: AppMode = .test
#else
let appMode: AppMode = .release
#endif

var isTestMode: Bool = appMode == .test
