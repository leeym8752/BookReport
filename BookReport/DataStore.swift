//
//  DataStore.swift
//  BookReport
//
//  Created by 이예민 on 2021/06/15.
//

import Foundation

struct Response: Codable {
    let total: Int
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case total
        case books = "items"
    }
}

struct Book: Codable {
    let title: String
    let description: String
    let author: String
    let publisher: String
    let thumbnailPath: String
//    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case author = "author"
        case publisher = "publisher"
        case thumbnailPath = "image"
//        case previewURL = "previewUrl"
    }
}
