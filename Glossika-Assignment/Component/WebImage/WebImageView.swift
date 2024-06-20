//
//  WebImageView.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/20.
//

import SwiftUI

struct WebImageView: View {
    
    @StateObject private var loader: WebImageLoader
    private let placeholder: Image

    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: WebImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
                    .resizable()
            }
        }
        .onAppear(perform: loader.load)
    }
}

struct WebImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WebImageView(url: URL(string: "https://cdn.pixabay.com/photo/2018/04/24/17/51/fairy-3347588_1280.png")!)
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipped()
                .foregroundColor(Color(white: 0.97))
            WebImageView(url: URL(string: "https://example.com/invalid-url.jpg")!)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .clipped()
                .foregroundColor(Color(white: 0.97))
                .previewDisplayName("With invalid URL")
        }
    }
}
