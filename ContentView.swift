//
//  ContentView.swift
//  BinIt
//
//  Created by Can Dindar on 20/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    @State private var rectanglesOffset: CGSize = .zero
    @State private var previousOffset: CGFloat = 0
    @State private var fallingItems: [FallingItem] = []
    @State private var score = 0
    @State private var isGameOver = false
    @State private var isPaused = true  // Start in pause state!
    @State private var isInfoPresented = false
    @State private var alertMessage = ""
    
    let plasticEmojis = ["🧃", "🍼", "🧴", "🪥", "🎈", "🍬", "🔌"]
    let glassEmojis = ["🍾", "🍷", "🍶", "🫙", "🫗", "🌡️", "🔮", "🏺", "🔍", "🪩"]
    let paperEmojis = ["📄", "📜", "📦", "📕", "📰", "✉️", "🗞️"]
    
    let itemSize: CGFloat = 60
    let rectSize: CGSize = CGSize(width: 150, height: 160)
    
    @State private var itemSpawnTimer: Timer?
    @State private var itemMoveTimer: Timer?
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View { 
        ZStack {
                   // Main Game View
                   gameView
                   
                   // Onboarding View on top
                   if showOnboarding {
                       OnboardingView(showOnboarding: $showOnboarding, isPaused: $isPaused)
                           .transition(.opacity)
                           .zIndex(1)
                   }
               }
            .onChange(of: showOnboarding) { newValue in
                if !newValue {
                    isPaused = false
                    startGameLoop()
                }
            }
        }
    
    var gameView: some View {
        NavigationView {
            ZStack {
                Color.cyan.ignoresSafeArea()
                
                if isPaused {
                    Color.gray.opacity(0.5).ignoresSafeArea()
                }

                HStack(spacing: 5) {
                    Image("paperBlue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: rectSize.width, height: rectSize.height)
                    
                    Image("plasticYellow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: rectSize.width, height: rectSize.height)
                    
                    Image("glassGreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: rectSize.width, height: rectSize.height)
                }
                .offset(rectanglesOffset)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            rectanglesOffset = CGSize(width: previousOffset + value.translation.width, height: 0)
                        }
                        .onEnded { value in
                            previousOffset += value.translation.width  // Save last position
                        }
                )
                
                ForEach(fallingItems) { item in
                    Text(item.emoji)
                        .font(.system(size: itemSize))
                        .position(x: item.x, y: item.y)
                }
            }
            .onAppear {
                startGameLoop()
            }
            .onChange(of: isInfoPresented) { newValue in
                if !newValue {
                    togglePause()
                }
            }
            .alert("Game Over", isPresented: $isGameOver) {
                Button("Restart", action: restartGame)
            } message: {
                Text(alertMessage)
            }
            .toolbar {
                
                ToolbarItem(placement: .principal) {
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.top, 20)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        togglePause()
                    } label: {
                        
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(15)
                            .padding(.trailing, 15)
                            .padding(.top, 20)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isInfoPresented.toggle()
                        togglePause()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(15)
                            .padding(.leading, 15)
                            .padding(.top, 40)
                    }
                }
            }
            .sheet(isPresented: $isInfoPresented) {
                InfoView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func startGameLoop() {
        if isGameOver { return }

        itemSpawnTimer?.invalidate()
        itemMoveTimer?.invalidate()

        itemSpawnTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            DispatchQueue.main.async {
                if !isGameOver && !isPaused { spawnItem() }
            }
        }

        itemMoveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            DispatchQueue.main.async {
                if !isGameOver && !isPaused { updateItems() }
            }
        }
    }
    
    func spawnItem() {
        let randomIndex = Int.random(in: 0..<3)
        var emojiArray: [String] = []
        switch randomIndex {
        case 0:
            emojiArray = paperEmojis
        case 1:
            emojiArray = plasticEmojis
        case 2:
            emojiArray = glassEmojis
        default:
            emojiArray = paperEmojis
        }
        
        let randomEmoji = emojiArray.randomElement() ?? "📄"
        let item = FallingItem(
            id: UUID(),
            emoji: randomEmoji,
            x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
            y: 0
        )
        
        fallingItems.append(item)
    }
    
    func updateItems() {
        for i in fallingItems.indices {
            fallingItems[i].y += 5

            let binTopY = UIScreen.main.bounds.height - 250
            
            if fallingItems[i].y >= binTopY {
                let matched = checkCollision(item: fallingItems[i])

                if !matched {
                    wrongSortingAlert(item: fallingItems[i])
                } else {
                    score += 1
                }

                fallingItems.remove(at: i)
                break
            }
        }
    }
    
    func wrongSortingAlert(item: FallingItem) {
        isGameOver = true
        let correctBin: String
        let wrongBin: String

        switch item.emoji {
        case _ where paperEmojis.contains(item.emoji):
            correctBin = "Paper Bin"
        case _ where plasticEmojis.contains(item.emoji):
            correctBin = "Plastic Bin"
        case _ where glassEmojis.contains(item.emoji):
            correctBin = "Glass Bin"
        default:
            correctBin = "Unknown Bin"
        }

        let binsStartX = (UIScreen.main.bounds.width - (rectSize.width * 3 + 10)) / 2 + rectanglesOffset.width
        let rectIndex = Int((item.x - binsStartX) / (rectSize.width + 5))

        switch rectIndex {
        case 0:
            wrongBin = "Paper Bin"
        case 1:
            wrongBin = "Plastic Bin"
        case 2:
            wrongBin = "Glass Bin"
        default:
            wrongBin = "Unknown Bin"
        }

        alertMessage = "Oops! You placed \(item.emoji) in the \(wrongBin), but it belongs in the \(correctBin).\nYour score is \(score)."
    } 

    func checkCollision(item: FallingItem) -> Bool {
        let binsStartX = (UIScreen.main.bounds.width - (rectSize.width * 3 + 10)) / 2 + rectanglesOffset.width
        let rectIndex = Int((item.x - binsStartX) / (rectSize.width + 5))
        
        if rectIndex >= 0, rectIndex < 3 {
            let currentMaterialEmojis: [String]
            switch rectIndex {
            case 0:
                currentMaterialEmojis = paperEmojis
            case 1:
                currentMaterialEmojis = plasticEmojis
            case 2:
                currentMaterialEmojis = glassEmojis
            default:
                currentMaterialEmojis = paperEmojis
            }
            
            if currentMaterialEmojis.contains(item.emoji) {
                return true
            }
        }
        return false
    }
    
    func restartGame() {
        score = 0
        fallingItems.removeAll()
        rectanglesOffset = .zero
        isGameOver = false
        isPaused = false
        startGameLoop()
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
}

#Preview {
    ContentView()
}
