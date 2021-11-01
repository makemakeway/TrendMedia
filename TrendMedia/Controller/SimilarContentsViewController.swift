//
//  SimilarContentsViewController.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/31.
//

import UIKit
import Kingfisher

class SimilarContentsViewController: UIViewController {
    //MARK: Property
    var movies = [MovieModel]()
    var genres: [Int:String] = [:]
    var mediaType: String = ""
    var page = 1
    var id = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: Method
    
    func collectionViewConfig() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: self.collectionView.frame.size.height * 0.6)
        layout.scrollDirection = .horizontal
        
        self.collectionView.collectionViewLayout = layout
    }
    
    func addGenreDictionary() {
        MovieAPIManager.shared.fetchGenres(mediaType: mediaType) { json in
            let genres = json["genres"].arrayValue
            genres.forEach({
                let id = $0["id"].intValue
                let name = $0["name"].stringValue
                self.genres.updateValue(name, forKey: id)
            })
        }
    }
    
    func fetchMovies() {
        MovieAPIManager.shared.fetchSimilarContents(category: mediaType, id: id, page: page) { json in
            let results = json["results"].arrayValue
            results.forEach({
                let movie = MovieModel(id: $0["id"].intValue,
                                       title: $0["title"].stringValue,
                                       original_language: $0["original_language"].stringValue,
                                       overview: $0["overview"].stringValue,
                                       original_title: $0["original_title"].stringValue,
                                       genre_ids: $0["genre_ids"].arrayValue.map {$0.intValue},
                                       vote_average: $0["vote_average"].doubleValue,
                                       media_type: $0["media_type"].stringValue,
                                       poster_path: $0["poster_path"].stringValue,
                                       backdrop_path: $0["backdrop_path"].stringValue,
                                       name: $0["name"].stringValue,
                                       original_name: $0["original_name"].stringValue)
                self.movies.append(movie)
            })
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        collectionViewConfig()
        let nib = UINib(nibName: SimilarContentsCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: SimilarContentsCollectionViewCell.identifier)
        
        self.collectionView.backgroundColor = .blue
        
        addGenreDictionary()
        fetchMovies()
        
    }
    

}


extension SimilarContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarContentsCollectionViewCell.identifier, for: indexPath) as? SimilarContentsCollectionViewCell else {
            print("cell init failed")
            return UICollectionViewCell()
        }
        
        let data = movies[indexPath.row]

        cell.backgroundColor = .white
        cell.genresLabel.text = ""
        data.genre_ids.forEach({
            cell.genresLabel.text! += "#\(genres[$0]!) "
        })

        switch mediaType {
        case "tv":
            cell.titleLabel.text = data.name!
        case "movie":
            cell.titleLabel.text = data.title!
        default:
            print("error")
        }
        
        let urlString = EndPoint.MEDIA_IMAGE_URL + (data.poster_path)
        cell.posterImage.kf.setImage(with: URL(string: urlString), placeholder: UIImage(systemName: "star"))
        
        
        return cell
    }
    
    
}
