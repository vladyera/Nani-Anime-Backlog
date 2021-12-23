//
//  WatchlistViewController.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/22/21.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    @IBOutlet weak var watchlistTableView: UITableView!
    let coreDataManager = CoreDataManager()
    
    private var anime: [AnimeShowMO] = []
    private let cellIdentifier = "WatchlistCell"
    
    private var showCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anime = coreDataManager.fetchAnime().filter({$0.isWatched == showCompleted})
        print(anime.count)
        watchlistTableView.register(.init(nibName: "WatchlistCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.separatorStyle = .none
        watchlistTableView.reloadData()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showCompleted = false
        } else {
            showCompleted = true
        }
        anime = coreDataManager.fetchAnime().filter({$0.isWatched == showCompleted})
        watchlistTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        anime = coreDataManager.fetchAnime().filter({$0.isWatched == showCompleted})
        watchlistTableView.reloadData()
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anime.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WatchlistCell
        cell?.configure(anime: anime[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    //Shitshow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animeShowMO = anime[indexPath.row]
        let anime = AnimeShow(id: animeShowMO.idForSearch!, attributes: .init(canonicalTitle: animeShowMO.title!, posterImage: .init(tiny: animeShowMO.smallPosterURL!, large: animeShowMO.largePosterURL!, small: animeShowMO.smallPosterURL!), description: animeShowMO.summary!, episodeCount: 0))
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! AnimePreviewViewController
        vc.anime = anime
        vc.cameFrom = .backlog
        self.present(vc, animated: true)
    }
}
