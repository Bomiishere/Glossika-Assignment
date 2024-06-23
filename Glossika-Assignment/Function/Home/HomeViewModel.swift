//
//  HomeViewModel.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/19.
//

import SwiftUI
import Combine

enum HomeLayout {
    case grid
    case video
}

class HomeViewModel: ObservableObject {
    
    @Published var homeCollections: [HomeCollection] = []
    @Published var layoutType: HomeLayout = .grid
    @Published var error: HTTPServiceError? = nil
    @Published var warning: String? = nil
    @Published var success: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    private let homeCollectionService = HomeCollectionService()
    
    init() {
        loadMockData()
    }
    
    func toggleTag(_ isTagged: Bool) {
        self.success = isTagged ? "Saved" : "Removed"
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
            HomeCollection(type: .recent, title: "Recent", stories: [
                Story(id: "recent_1", title: "Butter Flies", subTitle: "Smile sunshine, sea in the sky", author: "Harper G", thumbnailUrl: "https://cdn.pixabay.com/photo/2018/04/24/17/51/fairy-3347588_1280.png", videoUrl: "https://cdn.pixabay.com/video/2024/03/30/206272_large.mp4", videoThumbnailUrl: "https://cdn.pixabay.com/photo/2018/04/24/17/51/fairy-3347588_1280.png"),
            ]),
            HomeCollection(type: .recommend, title: "Recommended", stories: [
                Story(id: "recommend_1", title: "Tea Tea", subTitle: "Sami Indenstry howser in Maison Miyaca with New Teddy", author: "Sabrina Carpenter", thumbnailUrl: "https://cdn.pixabay.com/photo/2019/03/02/23/10/trees-4030861_1280.png", videoUrl: "", videoThumbnailUrl: ""),
                Story(id: "recommend_2", title: "Please Please Please", subTitle: "Please Please Please Trace", author: "Sabrina Carpenter", thumbnailUrl: "https://t2.genius.com/unsafe/504x504/https%3A%2F%2Fimages.genius.com%2Ff8f6cd01e585206e6f507b246b95962f.1000x1000x1.png", videoUrl: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4", videoThumbnailUrl: "https://upload.wikimedia.org/wikipedia/zh/c/cc/Usavich_season3_dvd.png"),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2024/05/25/213616_tiny.mp4", videoThumbnailUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2024/03/01/202587-918431513_large.mp4", videoThumbnailUrl: "https://cdn.pixabay.com/photo/2018/05/22/06/24/art-3420626_1280.png"),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2017/01/15/7350-199627510_large.mp4", videoThumbnailUrl: ""),
            ]),
            HomeCollection(type: .popular, title: "Popular", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", author: "Author 1", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/museo/timeline/1953/1953_divisione_casalinghi.jpg", videoUrl: "https://cdn.pixabay.com/video/2023/10/02/183279-870457579_large.mp4", videoThumbnailUrl: ""),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", author: "Author 2", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/museo/timeline/1955/1954_CP_casalinghi.jpg", videoUrl: "https://cdn.pixabay.com/video/2023/11/02/187612-880737125_large.mp4", videoThumbnailUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/museo/timeline/1956/1.jpg", videoUrl: "https://cdn.pixabay.com/video/2023/11/12/188861-883827797_large.mp4", videoThumbnailUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2024/03/31/206294_tiny.mp4", videoThumbnailUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2023/07/20/172451-847505208_large.mp4", videoThumbnailUrl: ""),
            ]),
            HomeCollection(type: .latest, title: "Latest", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", author: "Author 1", thumbnailUrl: "https://upload.wikimedia.org/wikipedia/zh/a/ac/NewJeans-New_Jeans.jpg", videoUrl: "https://sample-videos.com/video321/mp4/360/big_buck_bunny_360p_1mb.mp4", videoThumbnailUrl: ""),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", author: "Author 2", thumbnailUrl: "https://wwd.com/wp-content/uploads/2023/09/NewJeans-Levis-501-campaign-2.jpg", videoUrl: "https://sample-videos.com/video321/mp4/240/big_buck_bunny_240p_2mb.mp4", videoThumbnailUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "https://nique.net/wp-content/uploads/2023/02/TJ6Sx8z8-982x611.png", videoUrl: "", videoThumbnailUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "https://image-cdn.hypb.st/https%3A%2F%2Fpopbee.com%2Fimage%2F2023%2F07%2Fnew-00-1.jpg?cbr=1&q=90", videoUrl: "", videoThumbnailUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "https://image-cdn.hypb.st/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2024%2F05%2F01%2Fnewjeans-takashi-murakami-right-now-mv-release-info-1.jpg?cbr=1&q=90", videoUrl: "https://youtu.be/-TDVKQjmf7c", videoThumbnailUrl: ""),
            ]),
            HomeCollection(type: .favorite, title: "Your Favorites", stories: [
                Story(id: "1", title: "Story 1", subTitle: "Subtitle 1", author: "Author 1", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/special-projects/202304-luceviva/luceviva_copertina.jpg", videoUrl: "https://cdn.pixabay.com/video/2024/06/06/215500_tiny.mp4", videoThumbnailUrl: ""),
                Story(id: "2", title: "Story 2", subTitle: "Subtitle 2", author: "Author 2", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/News/20240529ParisDesigner/copertina.jpg", videoUrl: "https://cdn.pixabay.com/video/2023/07/28/173530-849610807_large.mp4", videoThumbnailUrl: ""),
                Story(id: "3", title: "Story 3", subTitle: "Subtitle 3", author: "Author 3", thumbnailUrl: "https://d3trhmpc56lg1h.cloudfront.net/Media/KARTELL/KARTELL/Images/Global/News/20231018-4RCH/banner1680x700_.jpg", videoUrl: "https://cdn.pixabay.com/video/2024/05/30/214500_large.mp4", videoThumbnailUrl: ""),
                Story(id: "4", title: "Story 4", subTitle: "Subtitle 4", author: "Author 4", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2021/03/08/67358-521707474_tiny.mp4", videoThumbnailUrl: ""),
                Story(id: "5", title: "Story 5", subTitle: "Subtitle 5", author: "Author 5", thumbnailUrl: "", videoUrl: "https://cdn.pixabay.com/video/2024/03/25/205553-927347775_large.mp4", videoThumbnailUrl: "https://cdn.pixabay.com/photo/2018/05/03/17/15/flower-pot-3371872_1280.png"),
            ])
        ]
        self.homeCollections = mockData
    }
}
