//
//  SearchViewController.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var searchTableView: UITableView!
    let cellIdentifier = "SearchCell"
    let networkManager = NetworkManager()
//    let searchURL = "https://kitsu.io/api/edge/anime?filter[text]="
    
    var searchedAnime: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorStyle = .none
        searchTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.count >= 3 {
            let text = makeValidSearch(text: searchController.searchBar.text!)
            print("https://kitsu.io/api/edge/anime?filter[text]=\(text)")
            networkManager.downloadAnimeShows(from: "https://kitsu.io/api/edge/anime?filter[text]=\(searchController.searchBar.text!)") { animes in
                self.searchedAnime = animes
                self.searchTableView.reloadData()
            }
        }
    }
    
    //NEED TO UPDATE
    func makeValidSearch(text: String) -> String {
        var result = text
        while result.contains("  ") {
            result = result.replacingOccurrences(of: "  ", with: " ")
        }
        if result.last == " " {
            result.removeLast()
        }
        result = result.replacingOccurrences(of: " ", with: "%")
        result = result.replacingOccurrences(of: ",", with: "")
        result = result.replacingOccurrences(of: ".", with: "")
        return result
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! AnimePreviewViewController
        vc.anime = searchedAnime[indexPath.row]
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedAnime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        cell.configure(with: searchedAnime[indexPath.row])
        return cell
    }
}
