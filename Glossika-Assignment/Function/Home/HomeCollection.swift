//
//  Story.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/19.
//

import Foundation
import Combine

enum HomeCollectionType: String, Codable {
    case recent
    case recommend
    case popular
    case latest
    case favorite
}

struct HomeCollection: Codable {
    let type: HomeCollectionType
    let title: String
    let stories: [Story]
}

struct Story: Identifiable, Codable {
    let id: String
    let title: String
    let subTitle: String
    let imageURL: String
    let author: String
}

class HomeCollectionService {
    func fetchHomeCollections() -> AnyPublisher<[HomeCollection], HTTPServiceError> {
        let url = URL(string: "https://mh.com/home/collections")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else {
                    throw HTTPServiceError(statusCode: -1, message: "HTTP response error")
                }
                guard 200..<300 ~= response.statusCode else {
                    throw HTTPServiceError(statusCode: response.statusCode, message: "HTTP status \(response.statusCode) error")
                }
                return result.data
            }
            .decode(type: [HomeCollection].self, decoder: JSONDecoder())
            .mapError { error in
                return HTTPServiceError(statusCode: -1, message: error.localizedDescription)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
