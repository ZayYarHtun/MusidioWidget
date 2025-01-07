//
//  AppDelegate.swift
//  MusidioHelper
//
//  Created by Zay Yar Htun on 5/31/22.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        openMainApp()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {}
    
    func openMainApp() {
        let mainAppBundleId = Bundle.main.bundleIdentifier?.replacingOccurrences(of: "Helper", with: "")
        
        guard let id = mainAppBundleId, NSRunningApplication.runningApplications(withBundleIdentifier: id).isEmpty else {
            NSApp.terminate(nil)
            return
        }
                
        let pathComponents = (Bundle.main.bundlePath as NSString).pathComponents
        let path = NSString.path(withComponents: Array(pathComponents[0...(pathComponents.count - 5)]))
        
        NSWorkspace.shared.launchApplication(path)
        NSApp.terminate(nil)
    }
    
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

