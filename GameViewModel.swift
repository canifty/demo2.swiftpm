////
////  GameViewModel.swift
////  demo2
////
////  Created by Can Dindar on 16/02/25.
////
//
//import SwiftUI
//
//@MainActor
//class GameViewModel: ObservableObject {
//    @Published var rectanglesOffset: CGSize = .zero
//    @Published var fallingItems: [FallingItem] = []
//    @Published var score = 0
//    @Published var isGameOver = false
//    @Published var isPaused = false
//    @Published var alertMessage = ""
//
//    let plasticEmojis = ["🧃", "🛍️", "🍼", "🧴", "🪥", "🎈", "🍬", "🔌", "💾"]
//    let glassEmojis = ["🍾", "🥂", "🍷", "🥃", "🧊", "🍶", "🫙", "🫗", "💎", "🌡️", "🕰️",
//                       "🔮", "🏺", "🔍", "🪩"]
//    let paperEmojis = ["📄", "📜", "📃", "📦", "📗", "📘", "📕", "📰", "📝", "✉️", "📇",
//                       "📖", "📚", "🗞️", "🛍️", "📔"]
//
//    let itemSize: CGFloat = 60
//    let rectSize: CGSize = CGSize(width: 150, height: 60)
//
//    private var itemSpawnTimer: Timer?
//    private var itemMoveTimer: Timer?
//
//    func startGameLoop() {
//        if isGameOver { return }
//
//        itemSpawnTimer?.invalidate()
//        itemMoveTimer?.invalidate()
//
//        itemSpawnTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
//            DispatchQueue.main.async {
//                guard let self = self, !self.isGameOver, !self.isPaused else { return }
//                self.spawnItem()
//            }
//        }
//
//        itemMoveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
//            DispatchQueue.main.async {
//                guard let self = self, !self.isGameOver, !self.isPaused else { return }
//                self.updateItems()
//            }
//        }
//    }
//
//    func spawnItem() {
//        let categories = [paperEmojis, plasticEmojis, glassEmojis]
//        let randomCategory = categories.randomElement() ?? paperEmojis
//        let randomEmoji = randomCategory.randomElement() ?? "📄"
//        let item = FallingItem(
//            id: UUID(),
//            emoji: randomEmoji,
//            x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
//            y: 0
//        )
//
//        fallingItems.append(item)
//    }
//
//    func updateItems() {
//        let binTopY = UIScreen.main.bounds.height - 130  // Adjust if needed
//
//        for i in (0..<fallingItems.count).reversed() {
//            // Move emoji down
//            fallingItems[i].y += 5
//
//            // Prevent emojis from falling below the bins
//            if fallingItems[i].y >= binTopY {
//                fallingItems[i].y = binTopY  // Stop at the top of the bins
//                
//                // Check collision when emoji reaches the bins
//                let matched = checkCollision(item: fallingItems[i])
//                if matched {
//                    score += 1
//                } else {
//                    gameOver(failingItem: fallingItems[i])
//                }
//                fallingItems.remove(at: i)  // Remove the item after checking
//            }
//        }
//    }
//
//    func checkCollision(item: FallingItem) -> Bool {
//        let rectStartX = UIScreen.main.bounds.width / 2 + rectanglesOffset.width - rectSize.width * 1.5 - 5
//        let rectIndex = Int((item.x - rectStartX) / (rectSize.width + 5))
//
//        if rectIndex >= 0, rectIndex < 3 {
//            let currentMaterialEmojis = [paperEmojis, plasticEmojis, glassEmojis][rectIndex]
//            return currentMaterialEmojis.contains(item.emoji)
//        }
//        return false
//    }
//
//    func gameOver(failingItem: FallingItem) {
//            isGameOver = true
//            var message = ""
//            switch failingItem.emoji {
//            case _ where paperEmojis.contains(failingItem.emoji):
//                message = "You caught a paper emoji with the wrong bin."
//            case _ where plasticEmojis.contains(failingItem.emoji):
//                message = "You caught a plastic emoji with the wrong bin."
//            case _ where glassEmojis.contains(failingItem.emoji):
//                message = "You caught a glass emoji with the wrong bin."
//            default:
//                message = "You made a mistake!"
//            }
//            alertMessage = message + "\nYour final score is \(score)."
//        }
//
//    func restartGame() {
//        score = 0
//        fallingItems.removeAll()
//        rectanglesOffset = .zero
//        isGameOver = false
//        isPaused = false
//        startGameLoop()
//    }
//
//    func togglePause() {
//        isPaused.toggle()
//    }
//}
