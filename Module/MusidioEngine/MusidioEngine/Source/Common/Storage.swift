//
//  UserDefaults.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/13/22.
//

import Foundation

public enum StorageKey: String {
    case lastPlayerData = "lastPlayerDataKey"
    case activatedLicenseData = "playerData"
}

public class Storage {
    public static let shared = Storage()
    
    private init() {}
    
    public static func save<T: Codable>(value: T, key: StorageKey) {
        UserDefaults.standard.setObject(value, forKey: key.rawValue)
    }
    
    public static func get<T: Codable>(_ type: T.Type, key: StorageKey) -> T? {
        return UserDefaults.standard.getObject(type, forKey: key.rawValue)
    }
}

extension UserDefaults {
    public func setObject<T: Codable>(_ object: T, forKey: String) {
        do {
            let encodedData = try JSONEncoder().encode(object)
            set(encodedData, forKey: forKey)
        } catch {
            print("JSONEncoding error!!!")
        }
    }
    
    public func getObject<T: Codable>(_ type: T.Type, forKey: String) -> T? {
        do {
            if let data = data(forKey: forKey) {
                return try JSONDecoder().decode(type, from: data)
            }
        } catch {
            print("JSONDecoding error!!!")
        }
        return nil
    }
    
}
