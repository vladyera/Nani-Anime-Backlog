//
//  NetworkManager.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

//Class responsible for downloading data (Anime list) from the public API

import Foundation

class NetworkManager {
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func downloadAnimeShows(from url: String, completion: @escaping ([AnimeShow])->()) {
        guard let url = URL(string: url) else { return }
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                if let decodedResponse = try? self.decoder.decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        completion(decodedResponse.data)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
