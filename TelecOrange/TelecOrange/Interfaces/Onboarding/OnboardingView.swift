//
//  OnboardingView.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var index = 0
    
    var body: some View {
        switch index {
        case 0:
            OnboardingFirstStepView(index: $index)
        default:
            OnboardingSecondStepView()
        }
    }
}

#Preview {
    OnboardingView()
}
