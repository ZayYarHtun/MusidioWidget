//
//  NSObject.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/9/22.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
