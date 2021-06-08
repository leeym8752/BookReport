//
//  DataStore.swift
//  BookReport
//
//  Created by 이예민 on 2021/06/08.
//

import Foundation

class dataManager {
    
    static let shared: dataManager = dataManager()
    var searchResult: SearchResult?
    
    private init () {
    }
    
}

struct SearchResult: Codable {
    struct BookInfo: Codable {
        let title: String
        let link: String
        let image: String
        let author: String
        let price: String
        let publisher: String
        let pubdate: String
        let isbn: String
        let description: String
    }
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [BookInfo]
}
