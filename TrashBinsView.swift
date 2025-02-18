////
////  TrashBinsView.swift
////  demo2
////
////  Created by Can Dindar on 16/02/25.
////
//
//import SwiftUI
//
//struct TrashBinsView: View {
//    @Binding var rectanglesOffset: CGSize
//    let rectSize: CGSize = CGSize(width: 150, height: 160)
//
//    var body: some View {
//        HStack(spacing: 5) {
//            Image("paperBlue").resizable().scaledToFit().frame(width: rectSize.width, height: rectSize.height)
//            Image("plasticYellow").resizable().scaledToFit().frame(width: rectSize.width, height: rectSize.height)
//            Image("glassGreen").resizable().scaledToFit().frame(width: rectSize.width, height: rectSize.height)
//        }
//        .offset(rectanglesOffset)
//        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
//        .gesture(DragGesture().onChanged { value in
//            rectanglesOffset = CGSize(width: value.translation.width, height: 0)
//        })
//    }
//}
