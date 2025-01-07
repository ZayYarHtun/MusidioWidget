//
//  UIStoryboard.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/9/22.
//

import AppKit

extension NSStoryboard {
    enum Storyboard: String {
        case main = "Main"
        
        func instanceVC(_ id: String) -> NSViewController {
            return NSStoryboard(name: self.rawValue, bundle: nil).instantiateController(withIdentifier: id) as! NSViewController
        }
        
        func instanceWC(_ id: String) -> NSWindowController {
            return NSStoryboard(name: self.rawValue, bundle: nil).instantiateController(withIdentifier: id) as! NSWindowController
        }
        
    }
    
    // MARK: - ViewControllers
    class func playerVC() -> NSViewController {
        return NSStoryboard.Storyboard.main.instanceVC(PlayerVC.className)
    }
    
    class func generalVC() -> NSViewController {
        return NSStoryboard.Storyboard.main.instanceVC(GeneralVC.className)
    }
    
    class func aboutVC() -> NSViewController {
        return NSStoryboard.Storyboard.main.instanceVC(AboutVC.className)
    }
    
    // MARK: - WindowControllers
    class func prefWC() -> NSWindowController {
        let controller = PrefWC()
        return controller.preferenceWindowController
    }
    
}
