//
//  InfoView.swift
//  BinIt
//
//  Created by Can Dindar on 16/02/25.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Sorting Guide")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                // Paper Bin
                infoCard(
                    title: "Paper ",
                    color: Color.blue.opacity(0.2),
                    textColor: .blue,
                    emojis: ["📄", "📜", "📦", "📰", "✉️", "🗞️", "🛍️"]
                )
                
                // Plastic Bin
                infoCard(
                    title: "Plastic ",
                    color: Color.yellow.opacity(0.2),
                    textColor: .orange,
                    emojis: ["🧃", "🍼", "🧴", "🪥", "🎈", "🍬", "🔌"]
                )
                
                // Glass Bin
                infoCard(
                    title: "Glass ",
                    color: Color.green.opacity(0.2),
                    textColor: .green,
                    emojis: ["🍾", "🍷", "🍶", "🫙", "🫗", "🌡️", "🔮"]
                )
                
                // Close Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Got It!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
    
    private func infoCard(title: String, color: Color, textColor: Color, emojis: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)

                .fontWeight(.bold)
                .foregroundColor(textColor)
            
            Text(emojis.joined(separator: "  "))
                .frame(maxWidth: .infinity, alignment: .center)

                .font(.largeTitle)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(15)
    }
}

#Preview {
    InfoView()
}
