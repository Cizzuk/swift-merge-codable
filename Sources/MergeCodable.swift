//
//  MergeCodable.swift
//  swift-merge-codable
//
//  Created by Cizzuk on 2026/02/27.
//

import Foundation

public protocol MergeCodable: Codable {
    init()
}

extension MergeCodable {
    // Decode from JSON data
    static func decode(from data: Data) -> Self {
        // Try direct decode first
        if let decoded = try? JSONDecoder().decode(Self.self, from: data) {
            return decoded
        }
        
        // If decode fails (schema changed), merge saved data with defaults
        guard let savedJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let defaultData = try? JSONEncoder().encode(Self()),
              var defaultJSON = try? JSONSerialization.jsonObject(with: defaultData) as? [String: Any]
        else {
            return Self()
        }
        
        // Saved values override defaults
        defaultJSON.merge(savedJSON) { _, saved in saved }
        
        if let mergedData = try? JSONSerialization.data(withJSONObject: defaultJSON),
           let merged = try? JSONDecoder().decode(Self.self, from: mergedData) {
            return merged
        }
        
        return Self()
    }
    
    // Encode to JSON data
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
