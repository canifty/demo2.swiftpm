////
////  ContentView.swift
////  demo2
////
////  Created by Can Dindar on 16/02/25.
////
//
//import SwiftUI
//
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var viewModel = GameViewModel()
//    @State private var isInfoPresented = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.ignoresSafeArea()
//
//                if viewModel.isPaused {
//                    Color.gray.opacity(0.3).ignoresSafeArea()
//                }
//
//                Text("Score: \(viewModel.score)")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .position(x: UIScreen.main.bounds.width / 2, y: 50)
//
//                TrashBinsView(rectanglesOffset: $viewModel.rectanglesOffset)
//
//                ForEach(viewModel.fallingItems) { item in
//                    Text(item.emoji)
//                        .font(.system(size: viewModel.itemSize))
//                        .position(x: item.x, y: item.y)
//                }
//            }
//            .onAppear {
//                viewModel.startGameLoop()
//            }
//            .alert("Game Over", isPresented: $viewModel.isGameOver) {
//                Button("Restart", action: viewModel.restartGame)
//            } message: {
//                Text(viewModel.alertMessage)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: viewModel.togglePause) {
//                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
//                            .font(.title)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.gray.opacity(0.7))
//                            .cornerRadius(10)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        isInfoPresented.toggle()
//                    } label: {
//                        Image(systemName: "info.circle.fill")
//                            .font(.title)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.gray.opacity(0.7))
//                            .cornerRadius(10)
//                    }
//                }
//            }
//            .sheet(isPresented: $isInfoPresented) {
//                InfoView(isInfoPresented: $isInfoPresented)
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
