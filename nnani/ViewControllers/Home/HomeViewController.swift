//
//  ViewController.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/21/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var resultViewController: SearchViewController!
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
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
        case trending = "Trending"
        case topRated = "Top Rated"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupInitialView()
        setupCollectionView()
        downloadAnime()
    }
    
    private func setupInitialView() {
        self.title = "Anime List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //Setting up search
        resultViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let searchController = UISearchController(searchResultsController: resultViewController)
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = resultViewController
        definesPresentationContext = true
    }
    
    private func downloadAnime() {
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
    
    private func setupCollectionView() {
        homeCollectionView.dataSource = dataSource
        homeCollectionView.delegate = self
        homeCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),heightDimension: .fractionalHeight(1/2.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func secondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 12, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

//MARK: - Data Source
extension HomeViewController {
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, AnimeShow> {
        let dataSource = UICollectionViewDiffableDataSource<Section, AnimeShow>(collectionView: homeCollectionView) { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.trending.rawValue, for: indexPath) as! TrendingCell
                cell.configure(with: self.trendingAnime[indexPath.row])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.topRated.rawValue, for: indexPath) as! TopRatedCell
                cell.configure(with: self.topRatedAnime[indexPath.row])
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
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

//MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! AnimePreviewViewController
        if indexPath.section == 0 {
            vc.anime = trendingAnime[indexPath.row]
        } else {
            vc.anime = topRatedAnime[indexPath.row]
        }
        vc.cameFrom = .search
        self.present(vc, animated: true)
    }
}
