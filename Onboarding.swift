////
////  Onboarding.swift
////  demo2
////
////  Created by Can Dindar on 16/02/25.
////
//
//import SwiftUI
//
//struct OnboardingView: View {
//    @Binding var showOnboarding: Bool
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Welcome to the Recycling Game!")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            Text("Swipe the bins left and right to catch the falling waste items.")
//                .font(.title2)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            Text("Match each item to the correct bin to score points!")
//                .font(.title2)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            Image("recyclingIllustration")  // Add an image if you have one
//                .resizable()
//                .scaledToFit()
//                .frame(height: 200)
//                .padding()
//
//            Button(action: {
//                showOnboarding = false  // Hide onboarding
//            }) {
//                Text("Start Game!")
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    OnboardingView(showOnboarding: .constant(true))
//}
