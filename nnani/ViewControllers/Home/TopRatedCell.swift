//
//  TopRatedCell.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class TopRatedCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var animeNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialView()
    }
    
    func setupInitialView() {
        posterImageView.layer.cornerRadius = 10
        posterImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        animeNameLabel.text = ""
    }
    
    func configure(with anime: Anime) {
        self.animeNameLabel.text = anime.title
        guard let url = URL(string: anime.smallPoster) else { return }
        var task: URLSessionDataTask!
        self.posterImageView.image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.posterImageView.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                return
            }
            let newImage = UIImage(data: data)!
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.posterImageView.image = newImage
            }
        })
        task.resume()
    }
    
}
