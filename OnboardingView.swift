//
//  OnboardingView.swift
//  BinIt
//
//  Created by Can Dindar on 16/02/25.
//
import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @Binding var isPaused: Bool
    @State private var currentPage = 0
    private let totalPages = 3

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentPage) {
                    PageView(
                        title: "Welcome to BinIt! 🌍♻️",
                        description: "Did you know that millions of tons of waste end up in the wrong place every year? 😱",
                        image1: nil,
                        description2: "Your job is to catch the falling waste and sort it into the right bins.",
                        image2: nil,
                        description3: "Simple, right? Let's learn how! 🎮",
                        image3: nil,
                        currentPage: $currentPage,
                        totalPages: totalPages
                    )
                    .tag(0)

                    PageView(
                        title: "How to Play 🎮",
                        description: "Swipe left & right to move the bins.",
                        image1: nil,
                        description2: "Catch the falling waste in the correct bin.",
                        image2: nil,
                        description3: "Earn points for correct sorting!",
                        image3: nil,
                        currentPage: $currentPage,
                        totalPages: totalPages
                    )
                    .tag(1)

                    PageView(
                        title: "Which Waste Goes Where? 🤔",
                        description: "📄 Paper goes into the Blue Bin! 💙",
                        image1: "paperBlue",
                        description2: "🥤 Plastic goes into the Yellow Bin! 💛",
                        image2: "plasticYellow",
                        description3: "🍾 Glass goes into the Green Bin! 💚",
                        image3: "glassGreen",
                        currentPage: $currentPage,
                        totalPages: totalPages
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                if currentPage == totalPages - 1 {
                    Button(action: {
                               showOnboarding = false
                               isPaused = false // Unpause game
                    }) {
                        
                        Text("Start Game")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
}

struct PageView: View {
    let title: String
    let description: String
    let image1: String?
    let description2: String
    let image2: String?
    let description3: String
    let image3: String?
    @Binding var currentPage: Int
    let totalPages: Int

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            VStack(spacing: 15) {
                DescriptionWithImage(text: description, imageName: image1)
                DescriptionWithImage(text: description2, imageName: image2)
                DescriptionWithImage(text: description3, imageName: image3)
            }
            .padding(.horizontal)


            // Page Indicator
            HStack {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.green : Color.gray)
                        .frame(width: 10, height: 10)
                        .padding(2)
                }
            }
            .padding(.bottom, 15)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.9)) 
                .shadow(radius: 5)
        )
        .padding()
    }
}

struct DescriptionWithImage: View {
    let text: String
    let imageName: String?

    var body: some View {
        VStack {
            Text(text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true), isPaused: .constant(false))
}
