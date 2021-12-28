//
//  AnimePreviewViewController.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class AnimePreviewViewController: UIViewController {
    
    let coreDataManager = CoreDataManager()
    
    
    @IBOutlet weak var animeTableView: UITableView!
    
    var anime: Anime?
    var buttonTitle = "Save"
    
    private enum CellIdentifiers: String {
        case picture = "PictureCell"
        case description = "DescriptionCell"
    }
    
    enum CameFrom {
        case search
        case backlog
        case completed
    }
    
    var cameFrom: CameFrom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animeTableView.delegate = self
        animeTableView.dataSource = self
        animeTableView.separatorStyle = .none
        
        if let cameFrom = cameFrom {
            switch cameFrom {
            case .search:
                buttonTitle = "Save"
            case .backlog:
                buttonTitle = "Move to Completed"
            case .completed:
                buttonTitle = "Move to Backlog"
            }
        }
    }
    
    //Move this to the cell
    @IBAction func savePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Save to:", preferredStyle: .actionSheet)
        guard let anime = anime else {
            return
        }
        alert.addAction(UIAlertAction(title: "Backlog", style: .default , handler:{ (UIAlertAction)in
            self.coreDataManager.saveAnime(anime: anime, isWatched: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Completed", style: .default , handler:{ (UIAlertAction)in
            self.coreDataManager.saveAnime(anime: anime, isWatched: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true)
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
            cell.configure(with: anime, buttonTitle: buttonTitle)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.description.rawValue) as! DescriptionTableViewCell
            cell.descriptionLabel.text = anime.summary
            return cell
        }
    }
}
