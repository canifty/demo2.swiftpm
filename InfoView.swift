////
////  InfoView.swift
////  demo2
////
////  Created by Can Dindar on 16/02/25.
////
//
//import SwiftUI
//
//struct InfoView: View {
//    @Binding var isInfoPresented: Bool
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("How to Play")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(.blue)
//            
//            Text("1. Move the colored images left and right to catch the falling emojis.")
//                .font(.title2)
//                .padding()
//            
//            Text("2. Catch the emoji with the same material type to score points.")
//                .font(.title2)
//                .padding()
//            
//            Text("3. If you miss an emoji or catch the wrong emoji, the game is over.")
//                .font(.title2)
//                .padding()
//
//            Button("Close") {
//                isInfoPresented = false
//            }
//            .font(.title2)
//            .foregroundColor(.blue)
//            .padding()
//        }
//        .padding()
//    }
//}
//
//
////#Preview {
////    InfoView()
////}
