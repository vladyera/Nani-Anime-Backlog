//
//  AnimePreviewViewController.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class AnimePreviewViewController: UIViewController {
    
    @IBOutlet weak var animeTableView: UITableView!
    
    var anime: AnimeShow?
    
    private enum CellIdentifiers: String {
        case picture = "PictureCell"
        case description = "DescriptionCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animeTableView.delegate = self
        animeTableView.dataSource = self
        animeTableView.separatorStyle = .none
    }
    
}

extension AnimePreviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UIScreen.main.bounds.height / 1.5
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let anime = self.anime else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.picture.rawValue) as! PictureTableViewCell
            cell.configure(with: anime)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.description.rawValue) as! DescriptionTableViewCell
            cell.descriptionLabel.text = anime.attributes.description
            return cell
        }
    }
}
