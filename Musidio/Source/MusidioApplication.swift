//
//  MusidioApplication.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/18/22.
//

import AppKit

class MusidioApplication: NSApplication {
    let appDelegate = AppDelegate()
    
    override init() {
        super.init()
        delegate = appDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
