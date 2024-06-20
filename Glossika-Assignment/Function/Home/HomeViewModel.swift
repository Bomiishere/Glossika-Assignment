//
//  HomeViewModel.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/19.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var homeCollections: [HomeCollection] = []
    @Published var error: HTTPServiceError? = nil
    @Published var warning: String? = nil
    private var cancellables: Set<AnyCancellable> = []
    private let homeCollectionService = HomeCollectionService()
    
    init() {
        loadMockData()
    }
    
    func fetchHomeCollections() {
        homeCollectionService.fetchHomeCollections()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = error
                    }
                case .finished:
                    break
                }
            }, receiveValue: { homeCollections in
                self.homeCollections = homeCollections
            })
            .store(in: &cancellables)
    }
    
    func loadMockData() {
        let mockData: [HomeCollection] = [
            HomeCollection(type: .recent, title: "Recent Stories", stories: [
                Story(id: "recent_1", title: "Butter Flies", subTitle: "Smile sunshine, sea in the sky", author: "Harper G", thumbnailUrl: "https://cdn.pixabay.com/photo/2018/04/24/17/51/fairy-3347588_1280.png", videoUrl: "https://cdn.pixabay.com/video/2024/03/25/205553-927347775_large.mp4"),
            ]),
            HomeCollection(type: .recommend, title: "Recommended Stories", stories: [
                Story(id: "recommend_1", title: "Tea Tea", subTitle: "Sami Indenstry, Maison Miyaca & New debby", author: "Sabrina Carpenter", thumbnailUrl: "https://cdn.pixabay.com/photo/2019/03/02/23/10/trees-4030861_1280.png", videoUrl: ""),
                Story(id: "recommend_2", title: "Please Please Please", subTitle: "Please Please Please Trace", author: "Sabrina Carpenter", thumbnailUrl: "https://t2.genius.com/unsafe/504x504/https%3A%2F%2Fimages.genius.com%2Ff8f6cd01e585206e6f507b246b95962f.1000x1000x1.png", videoUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "", videoUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: ""),
            ]),
            HomeCollection(type: .popular, title: "Popular Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", author: "Author 1", thumbnailUrl: "", videoUrl: ""),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", author: "Author 2", thumbnailUrl: "", videoUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "", videoUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: ""),
            ]),
            HomeCollection(type: .latest, title: "Latest Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", author: "Author 1", thumbnailUrl: "", videoUrl: ""),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", author: "Author 2", thumbnailUrl: "", videoUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "", videoUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: ""),
            ]),
            HomeCollection(type: .favorite, title: "Favorite Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", author: "Author 1", thumbnailUrl: "", videoUrl: ""),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", author: "Author 2", thumbnailUrl: "", videoUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "", videoUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: ""),
            ])
        ]
        self.homeCollections = mockData
    }
}
