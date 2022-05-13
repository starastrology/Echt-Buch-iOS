//
//  Post.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 5/4/22.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let id: Int
    let text, dateTime: String
    let toInd, fromInd: Individual

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case dateTime = "date_time"
        case toInd = "to_ind"
        case fromInd = "from_ind"
    }
}
