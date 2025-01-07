//
//  AboutVC.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/27/22.
//

import Cocoa
import Settings
import Combine

class AboutVC: NSViewController, SettingsPane {
    let paneIdentifier: Settings.PaneIdentifier = Settings.PaneIdentifier.about
    let paneTitle: String = "About"
    
    var toolbarItemIcon: NSImage {
      if #available(macOS 11.0, *) {
        return NSImage(systemSymbolName: "info.circle", accessibilityDescription: "AboutTabIcon")!
      } else {
        // Fallback on earlier versions
        return NSImage(named: NSImage.infoName)!
      }
    }

    @IBOutlet weak var lblVersion: NSTextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        let version = Bundle.main.releaseVersionNumber ?? "error"
        let build = Bundle.main.buildVersionNumber ?? "error"
        lblVersion.stringValue = "v\(version) (\(build))"
    }
    
    // MARK: - Actions
    @IBAction func btnCheckForUpdatesTapped(_ sender: Any) {
        AppUpdateController.shared.checkForUpdate(sender)
    }
}
