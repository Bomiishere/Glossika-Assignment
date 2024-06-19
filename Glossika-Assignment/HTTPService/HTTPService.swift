//
//  HTTPService.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/19.
//

import Foundation

struct HTTPServiceError: Error, Identifiable {
    var id: Int { statusCode }
    let statusCode: Int
    let message: String
}
