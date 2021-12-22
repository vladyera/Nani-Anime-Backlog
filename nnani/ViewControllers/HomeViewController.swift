//
//  ViewController.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Variables and constants
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    //URLs
    private let trendingURL = "https://kitsu.io/api/edge/trending/anime"
    private let topRatedURL = "https://kitsu.io/api/edge/anime?sort=-averageRating"
    
    private let networkManager = NetworkManager()
    
    private var trendingAnime: [AnimeShow]  = []
    private var topRatedAnime: [AnimeShow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadAnime()
    }
    
    func downloadAnime() {
        networkManager.downloadAnimeShows(from: trendingURL) { trendingShows in
            self.trendingAnime.append(contentsOf: trendingShows)
            print("Trending: \(self.trendingAnime.count)")
            self.networkManager.downloadAnimeShows(from: self.topRatedURL) { topRatedShows in
                self.topRatedAnime.append(contentsOf: topRatedShows)
                print("Top Rated: \(self.topRatedAnime.count)")
            }
        }
    }
}

