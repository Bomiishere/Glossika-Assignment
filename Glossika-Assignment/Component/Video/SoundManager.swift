//
//  SoundManager.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/22.
//

import Foundation

import Combine

class SoundManager: ObservableObject {
    
    static let shared = SoundManager()
    
    @Published var volume: Float {
        didSet {
            UserDefaults.standard.set(volume, forKey: "volume")
        }
    }
    
    var isMuted: Bool {
        volume == 0
    }
    
    init() {
        self.volume = UserDefaults.standard.float(forKey: "volume")
    }
    
    func toggleSound() {
        if isMuted {
            volume = 1.0
        } else {
            volume = 0
        }
    }
}
