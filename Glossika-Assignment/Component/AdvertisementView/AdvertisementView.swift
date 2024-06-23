//
//  AdvertisementView.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/24.
//

import SwiftUI

struct AdvertisementView: View {
    let images: [String] = ["ad-1", "ad-2", "ad-3", "ad-4", "ad-5"]
    @State private var currentIndex: Int = 0
    @State private var timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ForEach(0..<images.count, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .opacity(currentIndex == index ? 1 : 0)
                    .animation(.easeInOut(duration: 2), value: currentIndex == index)
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 250)
                .onTapGesture {
                    nextImage()
                }
                .onReceive(timer) { _ in
                    nextImage()
                }
        }
        .onTapGesture {
            nextImage()
        }
    }
    
    private func nextImage() {
        currentIndex = (currentIndex + 1) % images.count
    }
}
struct AdvertisementView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertisementView()
    }
}
