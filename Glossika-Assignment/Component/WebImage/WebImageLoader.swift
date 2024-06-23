//
//  WebImageLoader.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/20.
//

import SwiftUI
import Combine

class WebImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    private let url: URL
    private let cache = URLCache.shared

    init(url: URL) {
        self.url = url
    }

    func load() {
        let request = URLRequest(url: url)
        
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
                .map { (data, response) -> UIImage? in
                    if let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        return image
                    }
                    return nil
                }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.image = $0
                }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
