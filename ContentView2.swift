import SwiftUI

struct ContentView2: View {

    @State private var rectanglesOffset: CGSize = .zero
    @State private var fallingItems: [FallingItem] = []
    @State private var score = 0
    @State private var isGameOver = false
    @State private var isPaused = false
    @State private var isInfoPresented = false
    @State private var alertMessage = ""
    
    let plasticEmojis = ["🧃", "🍼", "🧴", "🪥", "🎈", "🍬", "🔌"]
    let glassEmojis = ["🍾", "🍷", "🍶", "🫙", "🫗", "🌡️",
                       "🔮", "🏺", "🔍", "🪩"]
    let paperEmojis = ["📄", "📜", "📦", "📕", "📰", "✉️", "🗞️"]
    
    let itemSize: CGFloat = 60
    let rectSize: CGSize = CGSize(width: 150, height: 160)
    
    @State private var itemSpawnTimer: Timer?
    @State private var itemMoveTimer: Timer?

    var body: some View {
        NavigationView {
            ZStack {
                Color.cyan.ignoresSafeArea()
                
                if isPaused {
                    Color.gray.opacity(0.5).ignoresSafeArea()
                }

                // Score display (Centered)
//                Text("Score: \(score)")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .position(x: UIScreen.main.bounds.width / 2, y: 50)
                
                // Images at the bottom (bins)
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
                .offset(rectanglesOffset) // Moves with touch
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            rectanglesOffset = CGSize(width: value.translation.width, height: 0)
                        }
                )
                
                // Falling items (emojis)
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
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        togglePause()
                    } label: {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isInfoPresented.toggle()  // Show the info sheet
                        togglePause()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                    }
                }
            }
            .sheet(isPresented: $isInfoPresented) {
                InfoView()  // Pass the binding to dismiss
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // For iPad compatibility
    }
    
    func startGameLoop() {
        if isGameOver { return }

        itemSpawnTimer?.invalidate()
        itemMoveTimer?.invalidate()

        // Item Spawning Timer
        itemSpawnTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            DispatchQueue.main.async {
                if !isGameOver && !isPaused { spawnItem() }
            }
        }

        // Item Movement Timer
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

            // Define the top boundary of the bins
            let binTopY = UIScreen.main.bounds.height - 250
            
            if fallingItems[i].y >= binTopY {
                let matched = checkCollision(item: fallingItems[i])

                // If the emoji is not caught in the bins, it falls past
                if !matched {
                    emojiFell(item: fallingItems[i])
                } else {
                    // If matched, increase score and remove item
                    score += 1
                }

                // Remove the item after it reaches the bin or falls off-screen
                fallingItems.remove(at: i)
                break
            }
        }
    }
    func emojiFell(item: FallingItem) {
        // Handle the case where the emoji falls past all bins
        isGameOver = true
        alertMessage = "The \(item.emoji) fell past all the bins!\nYour final score is \(score)."
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
                // If there’s a match, immediately remove the item
                return true
            }
        }
        return false
    }
    
    func gameOver(failingItem: FallingItem) {
        isGameOver = true
        var message = ""
        
        // Identify which bin the emoji was caught in
        let caughtBin: String
        switch rectanglesOffset.width {
        case _ where rectanglesOffset.width < UIScreen.main.bounds.width / 3:
            caughtBin = "Paper Bin"
        case _ where rectanglesOffset.width < 2 * UIScreen.main.bounds.width / 3:
            caughtBin = "Plastic Bin"
        default:
            caughtBin = "Glass Bin"
        }

        // Identify which material this emoji belongs to
        let correctBin: String
        switch failingItem.emoji {
        case _ where paperEmojis.contains(failingItem.emoji):
            correctBin = "Paper Bin"
        case _ where plasticEmojis.contains(failingItem.emoji):
            correctBin = "Plastic Bin"
        case _ where glassEmojis.contains(failingItem.emoji):
            correctBin = "Glass Bin"
        default:
            correctBin = "Unknown Bin"
        }

        // Compose message
        if caughtBin != correctBin {
            message = "You caught a \(failingItem.emoji) in the wrong bin!\n" +
                      "You placed it in the \(caughtBin), but it belongs in the \(correctBin)."
        } else {
            message = "You successfully caught the \(failingItem.emoji) in the \(correctBin)!"
        }

        alertMessage = message + "\nYour final score is \(score)."
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

struct FallingItem: Identifiable {
    let id: UUID
    let emoji: String
    var x: CGFloat
    var y: CGFloat
}


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
                    emojis: ["📄", "📜", "📦", "📕", "📰", "✉️", "🗞️"]
//                    description: "Paper, newspapers, books, and cardboard."
                )
                
                // Plastic Bin
                infoCard(
                    title: "Plastic ",
                    color: Color.yellow.opacity(0.2),
                    textColor: .orange,
                    emojis: ["🧃", "🛍️", "🍼", "🧴", "🪥", "🎈", "🍬", "🔌"]
//                    description: "Plastic bottles, bags, containers, and straws."
                )
                
                // Glass Bin
                infoCard(
                    title: "Glass ",
                    color: Color.green.opacity(0.2),
                    textColor: .green,
                    emojis: ["🍾", "🍷", "🍶", "🫙", "🫗", "🌡️", "🔮", "🏺"]
//                    description: "Glass bottles, jars, and fragile items."
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
                        .background(Color.blue)
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
            
//            Text(description)
//                .font(.body)
//                .foregroundColor(.black.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(15)
//        .shadow(radius: 3)
    }
}





#Preview {
    ContentView2()
}
