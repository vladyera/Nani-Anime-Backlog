//
//  AnimeShow.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import Foundation

struct Response: Codable {
    let data: [AnimeShow]
}

struct AnimeShow: Codable, Hashable {
    let id: String
    let attributes: Attributes
}

struct Attributes: Codable, Hashable {
    let canonicalTitle: String
    let posterImage: PosterImage
    let description: String
    let episodeCount: Int?
}

struct PosterImage: Codable, Hashable {
    let tiny, large, small: String
}
