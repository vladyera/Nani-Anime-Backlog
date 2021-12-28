//
//  SearchCell.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
    
    func configure(with anime: Anime) {
        titleLabel.text = anime.title
        guard let url = URL(string: anime.smallPoster) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                guard let downImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = downImage
                }
            }
        }
        task.resume()
    }
}
