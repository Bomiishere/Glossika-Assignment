//
//  VideoView.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/21.
//

import SwiftUI
import AVKit

struct VideoView: View {
    
    @State private var player: AVPlayer?
    @State private var isVideoLoaded = false
    @State private var isTagged = false
    
    var story: Story
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                
                ZStack() {
                    if let videoThumbnailUrl = URL(string: story.videoThumbnailUrl), !story.videoThumbnailUrl.isEmpty {
                        WebImageView(url: videoThumbnailUrl)
                            .frame(width: screenWidth, height: screenWidth)
                            .clipped()
                            .opacity(isVideoLoaded ? 0 : 1)
                            .foregroundColor(Color(white: 0.97))
                    } else if let thumbnailUrl = URL(string: story.thumbnailUrl), !story.thumbnailUrl.isEmpty {
                        WebImageView(url: thumbnailUrl)
                            .frame(width: screenWidth, height: screenWidth)
                            .clipped()
                            .opacity(isVideoLoaded ? 0 : 1)
                            .foregroundColor(Color(white: 0.97))
                    } else {
                        Color.gray.opacity(0.1)
                            .frame(width: screenWidth, height: screenWidth)
                            .overlay(
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(Color(white: 0.97))
                            )
                    }
                    
                    if let player = player {
                        CustomAVPlayerViewControllerRepresentable(player: player)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: screenWidth, height: screenWidth)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            
            HStack(alignment: .top) {
                Text(story.subTitle)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading)
                Spacer()
                Button {
                    isTagged.toggle()
                } label: {
                    Image(systemName: isTagged ? "tag.fill" : "tag")
                        .resizable()
                        .foregroundColor(.black.opacity(0.7))
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 4)
                        .shadow(color: Color.gray.opacity(0.35), radius: 2, x: 2, y: 2)
                }
                .padding(.horizontal, 8)
            }
            .padding(.bottom, 0)
            VStack(alignment: .leading) {
                Text(story.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(story.title)
                    .font(.subheadline).bold()
                    .foregroundColor(Color.hex("#343434"))
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .onAppear {
            if let videoUrl = URL(string: story.videoUrl), !story.videoUrl.isEmpty {
                loadVideoAsync(url: videoUrl)
            }
        }
        .onDisappear {
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    private func loadVideoAsync(url: URL) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            DispatchQueue.main.async {
                let avPlayer = AVPlayer(playerItem: playerItem)
                avPlayer.play() // 自動播放
                self.player = avPlayer
                NotificationCenter.default.addObserver(forName: .AVPlayerItemNewAccessLogEntry, object: avPlayer.currentItem, queue: .main) { _ in
                    self.isVideoLoaded = true
                }
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem, queue: .main) { _ in
                    avPlayer.seek(to: .zero)
                    avPlayer.play()
                }
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack {
                VideoView(story:
                            Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/museo/timeline/1956/1.jpg", videoUrl: "https://cdn.pixabay.com/video/2023/11/12/188861-883827797_large.mp4", videoThumbnailUrl: "")
                )
            }
            .background(.white)
        }
        .previewLayout(.device)
    }
}
