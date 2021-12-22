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
    
    private lazy var dataSource = configureDataSource()
    
    private enum CellIdentifiers: String {
        case trending = "TrendingCell"
        case topRated = "TopRatedCell"
    }
    
    private enum Section: String, CaseIterable {
        case topRated = "Top Rated"
        case trending = "Trending"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        downloadAnime()
    }
    
    func downloadAnime() {
        networkManager.downloadAnimeShows(from: trendingURL) { trendingShows in
            self.trendingAnime.append(contentsOf: trendingShows)
            print("Trending: \(self.trendingAnime.count)")
            self.networkManager.downloadAnimeShows(from: self.topRatedURL) { topRatedShows in
                self.topRatedAnime.append(contentsOf: topRatedShows)
                print("Top Rated: \(self.topRatedAnime.count)")
                self.updateSnapshot()
            }
        }
    }
    
    func setupCollectionView() {
        homeCollectionView.dataSource = dataSource
        homeCollectionView.register(.init(nibName: CellIdentifiers.trending.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.trending.rawValue)
        homeCollectionView.register(.init(nibName: CellIdentifiers.topRated.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.topRated.rawValue)
        homeCollectionView.collectionViewLayout = createLayout()
    }
}

//MARK: - Compositional Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.firstSection()
            case 1: return self.secondSection()
            default:
                return self.secondSection()
            }
        }
    }
    
    private func firstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(9/10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),heightDimension: .fractionalHeight(1/1.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func secondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 12, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

//MARK: - Data Source
extension HomeViewController {
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, AnimeShow> {
        let dataSource = UICollectionViewDiffableDataSource<Section, AnimeShow>(collectionView: homeCollectionView) { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.trending.rawValue, for: indexPath) as! TrendingCell
                cell.backgroundColor = .red
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.topRated.rawValue, for: indexPath) as! TopRatedCell
                cell.backgroundColor = .red
                return cell
            }
        }
        return dataSource
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnimeShow>()
        snapshot.appendSections([.trending, .topRated])
        snapshot.appendItems(trendingAnime, toSection: .trending)
        snapshot.appendItems(topRatedAnime, toSection: .topRated)
        dataSource.apply(snapshot)
    }
    
}
