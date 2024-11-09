//
//  TelecOrangeApp.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

@main
struct TelecOrangeApp: App {
    
    @StateObject var screenRootManager = ScreenRootManager.shared
    
    var body: some Scene {
        WindowGroup {
            switch screenRootManager.screenRoot {
            case .onboarding:
                OnboardingView()
            case .content:
                RemoteView()
            }
        }
    }
}
