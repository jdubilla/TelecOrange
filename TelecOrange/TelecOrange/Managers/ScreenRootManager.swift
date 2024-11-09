//
//  ScreenRootManager.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

enum ScreenRoot {
    case onboarding
    case content
}

class ScreenRootManager: ObservableObject {
    static let shared = ScreenRootManager()
    
    @Published var screenRoot: ScreenRoot
    
    init() {
        @AppStorage("mustShowOnboarding") var mustShowOnboarding: Bool = true
        screenRoot = mustShowOnboarding ? .onboarding : .content
    }
}

