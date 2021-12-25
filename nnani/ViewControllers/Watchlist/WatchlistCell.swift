//
//  WatchlistCell.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/22/21.
//

import UIKit

class WatchlistCell: UITableViewCell {
    @IBOutlet weak var animeNameLabel: UILabel!
    @IBOutlet weak var posterImageVIew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageVIew.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        posterImageVIew.image = nil
    }
    
    func configure(anime: AnimeShowMO) {
        animeNameLabel.text = anime.title
        guard let url = URL(string: anime.smallPosterURL ?? "") else { return }
        var task: URLSessionDataTask!
        self.posterImageVIew.image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.posterImageVIew.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                return
            }
            let newImage = UIImage(data: data)!
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.posterImageVIew.image = newImage
            }
        })
        task.resume()
    }
}
