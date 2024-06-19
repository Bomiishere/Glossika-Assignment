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
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", imageURL: "", author: "Author 1"),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", imageURL: "", author: "Author 2"),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", imageURL: "", author: "Author 3"),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", imageURL: "", author: "Author 4"),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", imageURL: "", author: "Author 5"),
            ]),
            HomeCollection(type: .recommend, title: "Recommended Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", imageURL: "", author: "Author 1"),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", imageURL: "", author: "Author 2"),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", imageURL: "", author: "Author 3"),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", imageURL: "", author: "Author 4"),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", imageURL: "", author: "Author 5"),
            ]),
            HomeCollection(type: .popular, title: "Popular Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", imageURL: "", author: "Author 1"),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", imageURL: "", author: "Author 2"),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", imageURL: "", author: "Author 3"),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", imageURL: "", author: "Author 4"),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", imageURL: "", author: "Author 5"),
            ]),
            HomeCollection(type: .latest, title: "Latest Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", imageURL: "", author: "Author 1"),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", imageURL: "", author: "Author 2"),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", imageURL: "", author: "Author 3"),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", imageURL: "", author: "Author 4"),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", imageURL: "", author: "Author 5"),
            ]),
            HomeCollection(type: .favorite, title: "Favorite Stories", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", imageURL: "", author: "Author 1"),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", imageURL: "", author: "Author 2"),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", imageURL: "", author: "Author 3"),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", imageURL: "", author: "Author 4"),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", imageURL: "", author: "Author 5"),
            ])
        ]
        self.homeCollections = mockData
    }
}
