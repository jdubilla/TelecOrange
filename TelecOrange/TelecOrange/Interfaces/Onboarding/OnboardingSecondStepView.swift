//
//  OnboardingSecondStepView.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

struct OnboardingSecondStepView: View {
    
    @AppStorage("mustShowOnboarding") var mustShowOnboarding: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderImageView()
            
            ContentView()
        }
        .ignoresSafeArea(.all, edges: [.top])
        .background(.grayLight)
        .task {
            await NetworkHelper.checkAllIPs()
        }
    }
}

extension OnboardingSecondStepView {
    // MARK: HeaderImageView
    @ViewBuilder
    private func HeaderImageView() -> some View {
        Image(.onboardingNetwork)
            .resizable()
            .scaledToFill()
            .frame(height: 300)
    }
    
    // MARK: ContentView
    @ViewBuilder
    private func ContentView() -> some View {
        Group {
            TitleAndDescriptionView()
            
            BottomButtonAndStepView()
        }
        .padding([.horizontal, .top])
    }
    
    // MARK: TitleAndDescriptionView
    @ViewBuilder
    private func TitleAndDescriptionView() -> some View {
        Text("onboarding_network")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
        
        Text("onboarding_network_description")
            .font(.title3)
            .multilineTextAlignment(.center)
    }
    
    // MARK: BottomButtonAndStepView
    @ViewBuilder
    private func BottomButtonAndStepView() -> some View {
        Spacer()
        
        HStack( spacing: 8) {
            Circle()
                .frame(width: 10, height: 10)
                .opacity(0.5)
            
            Circle()
                .frame(width: 10, height: 10)
        }
        
        Button("onboarding_finish") {
            mustShowOnboarding = false
            ScreenRootManager.shared.screenRoot = .content
        }
        .buttonStyle(NextButtonStyle())
        .padding(.bottom)
    }
}

#Preview {
    OnboardingSecondStepView()
}
