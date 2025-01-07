//
//  String.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/13/22.
//

import Foundation

extension Double {
    func convertTimeText() -> String {
        let int = Int(self)
        var minute = int / 60
        var second = int % 60
        
        if minute < 60 { // 0:00 format
            return "\(minute):\(String(format: "%02d", second))"
        } else { // 0:00:00 format
            let hour = int / 3600
            minute = (int % 3600) / 60
            second = (int % 3600) % 60
            return "\(hour):\((String(format: "%02d", minute))):\((String(format: "%02d", second)))"
        }

    }
}
