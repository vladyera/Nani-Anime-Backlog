//
//  PictureCell.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.contentMode = .scaleAspectFill
        saveButton.layer.cornerRadius = 8
    }
    
    func configure(with anime: Anime, buttonTitle: String) {
        saveButton.setTitle(buttonTitle, for: .normal)
        titleLabel.text = anime.title
        guard let url = URL(string: anime.largePoster) else { return }
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
