//
//  Log.swift
//  Musidio
//
//  Created by Zay Yar Htun on 8/22/24.
//

import Foundation
import OSLog

class Log {
    static let musidio = "com.mobdio.Musidio"
    static let playerUI = Logger(subsystem: musidio, category: "PlayerUI")
    static let playerMenu = Logger(subsystem: musidio, category: "PlayerMenu")
    
    static func jsonString(from data: Data) -> String? {
        do {
            // Attempt to convert the data to a JSON object
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

            // Now, convert the JSON object to Data with pretty-printed JSON format
            let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            
            // Finally, convert the Data to a String
            if let jsonString = String(data: prettyJsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
        return nil
    }
    
    static func jsonString(from dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
