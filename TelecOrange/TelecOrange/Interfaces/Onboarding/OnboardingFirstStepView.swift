//
//  OnboardingFirstStepView.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

struct OnboardingFirstStepView: View {
    
    @Binding var index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderImageView()
            
            ContentView()
        }
        .ignoresSafeArea(.all, edges: [.top])
        .background(.grayLight)
    }
}

extension OnboardingFirstStepView {
    // MARK: HeaderImageView
    @ViewBuilder
    private func HeaderImageView() -> some View {
        Image(.onboardingTelevision)
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
        Text("onboarding_welcome")
            .font(.title)
            .fontWeight(.bold)
        
        Text("onboarding_description")
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
            
            Circle()
                .frame(width: 10, height: 10)
                .opacity(0.5)
        }
        
        Button("onboarding_next") {
            index += 1
        }
        .buttonStyle(NextButtonStyle())
        .padding(.bottom)
    }
}

#Preview {
    OnboardingFirstStepView(index: .constant(0))
}
