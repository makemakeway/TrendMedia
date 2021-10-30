//
//  ViewController.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/15.
//

import UIKit
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController {
    
    
    var currentPage = 1
    
    var mediaData = [MovieModel]()
    var genres: [Int:String] = [:]
    var videoKey = ""
    var totalResult = 0

    //MARK: Property
    lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonClicked(_:)))
        button.tintColor = UIColor.darkGray
        
        return button
    }()
    
    lazy var mapButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonClicked(_:)))
        
        return button
    }()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(identifier: "KST")
        
        return df
    }()
    
    @IBOutlet weak var headerStackView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var dramaButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    var filmButtonPushed: Bool = false
    var dramaButtonPushed: Bool = false
    var bookButtonPushed: Bool = false
    
    
    
    //MARK: Method
    
    func headerStackViewConfig() {
        headerStackView.layer.cornerRadius = 15
        headerStackView.layer.shadowColor = UIColor.label.cgColor
        headerStackView.layer.shadowOpacity = 0.7
        headerStackView.layer.shadowOffset = CGSize.zero
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            filmButtonPushed.toggle()
            dramaButtonPushed = false
            bookButtonPushed = false
            
            if filmButtonPushed {
                switchButtonImage(filmButton, "film.fill")
                switchButtonImage(dramaButton, "tv")
                switchButtonImage(bookButton, "book")
                print("영화 카테고리")
            } else {
                switchButtonImage(filmButton, "film")
                print("카테고리 해제")
            }
            
        case 1:
            dramaButtonPushed.toggle()
            filmButtonPushed = false
            bookButtonPushed = false
            
            if dramaButtonPushed {
                print("드라마 카테고리")
                switchButtonImage(filmButton, "film")
                switchButtonImage(dramaButton, "tv.fill")
                switchButtonImage(bookButton, "book")
            } else {
                switchButtonImage(dramaButton, "tv")
                print("카테고리 해제")
            }
//            
        case 2:
            let sb = UIStoryboard.init(name: "BooksViewControllerStoryboard", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "BooksViewController") as! BooksViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        default:
            return
        }
    }
    
    func switchButtonImage(_ button: UIButton,_ image: String) {
        button.setImage(UIImage(systemName: image), for: .normal)
    }
    
    func addGenreDictionary() {
        MovieAPIManager.shared.fetchGenres(mediaType: "tv") { json in
            let genres = json["genres"].arrayValue
            
            for genre in genres {
                let id = genre["id"].intValue
                let name = genre["name"].stringValue
                self.genres.updateValue(name, forKey: id)
            }
        }
        MovieAPIManager.shared.fetchGenres(mediaType: "movie") { json in
            let genres = json["genres"].arrayValue
            for genre in genres {
                let id = genre["id"].intValue
                let name = genre["name"].stringValue
                self.genres.updateValue(name, forKey: id)
            }
        }
        
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat, view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: borderWidth)
        view.addSubview(border)
    }
    
    func addData() {
        
        DispatchQueue.global().async { [weak self] in
            guard let page = self?.currentPage else {
                return
            }
            MovieAPIManager.shared.fetchMovieData(dayOrWeek: .week, category: .all, page: page) { code, json in
                self?.totalResult = json["total_results"].intValue
                let movies = json["results"].arrayValue
                for movie in movies {
                    let data = MovieModel(id: movie["id"].intValue,
                                          title: movie["title"].stringValue,
                                          original_language: movie["original_language"].stringValue,
                                          release_date: movie["release_date"].stringValue,
                                          first_air_date: movie["first_air_date"].stringValue,
                                          overview: movie["overview"].stringValue,
                                          original_title: movie["original_title"].stringValue,
                                          genre_ids: movie["genre_ids"].arrayValue.map({ $0.intValue }),
                                          vote_average: movie["vote_average"].doubleValue,
                                          media_type: movie["media_type"].stringValue,
                                          poster_path: movie["poster_path"].stringValue,
                                          backdrop_path: movie["backdrop_path"].stringValue,
                                          origin_country: [movie["origin_country"].stringValue],
                                          name: movie["name"].stringValue,
                                          original_name: movie["original_name"].stringValue)
                    self?.mediaData.append(data)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    
    
    //MARK: Objc func
    
    @objc func searchButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard.init(name: "SearchViewStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController

        
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func mapButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard.init(name: "MapViewControllerStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func linkButtonPushed() {
        print("link Button clicked")
    }
    
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGenreDictionary()
        addData()
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.setLeftBarButtonItems([mapButton], animated: true)
        headerStackViewConfig()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
}

//MARK: Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mediaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.containerView.layer.shadowOffset = CGSize.zero
        cell.containerView.layer.shadowColor = UIColor.label.cgColor
        cell.containerView.layer.shadowOpacity = 0.5
        cell.containerView.layer.shadowRadius = 5
        cell.containerView.layer.cornerRadius = 10
        
        
        cell.posterImage.layer.cornerRadius = 10
        cell.posterImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let movieData = mediaData[indexPath.row]
        let urlString = EndPoint.MEDIA_IMAGE_URL + (movieData.poster_path)
        cell.posterImage.kf.setImage(with: URL(string: urlString), placeholder: UIImage(systemName: "star"))
        
        
        switch movieData.media_type {
        case "movie":
            cell.engTitle.text = movieData.original_title
            cell.engTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cell.korTitle.text = movieData.title
            cell.korTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cell.releaseDate.text = movieData.release_date!
        case "tv":
            cell.engTitle.text = movieData.original_name
            cell.engTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cell.korTitle.text = movieData.name
            cell.korTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cell.releaseDate.text = movieData.first_air_date!
        default:
            print("default")
        }
        
        cell.genreLabel.text = ""
        
        for genre in movieData.genre_ids {
            if let text = self.genres[genre] {
                cell.genreLabel.text! += "#" + text + " "
            }
            
        }

        cell.ratingLabel.text = String(format: "%.1f", movieData.vote_average ?? 0.0)
        
        let border = UIView()
        border.backgroundColor = .label
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: cell.footerView.frame.width - 2, height: 1)
        cell.footerView.addSubview(border)
        
        cell.linkButtonDelegate = self
        cell.linkButton.layer.cornerRadius = cell.linkButton.frame.size.width / 2
        cell.index = indexPath.row
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.height * 0.6
    }
    
    
    //MARK: MOVE TO ActorViewController
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sb = UIStoryboard.init(name: "ActorViewControllerStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ActorViewController") as! ActorViewController
        let movie = mediaData[indexPath.row]
        vc.movieInfo = movie
        
        self.navigationController?.pushViewController(vc, animated: true)
        return nil
    }
    
}

// MARK: TableView Pagenation
extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({ if $0.row == mediaData.count - 1 && mediaData.count < totalResult {
            currentPage += 1
            addData()
        }})
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

extension ViewController: LinkButtonDelegate {
    
    func linkButtonClicked(index: Int) {
        print("linkButton Clicked")
        let sb = UIStoryboard.init(name: "WebLinkViewControllerStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "WebLinkViewController") as! WebLinkViewController
        
        MovieAPIManager.shared.fetchVideoInfo(category: mediaData[index].media_type, mediaId: mediaData[index].id) { json in
            var videoKey = ""
            let result = json["results"].arrayValue
            videoKey = result[0]["key"].stringValue
            vc.linkKey = videoKey
            print(vc.linkKey)
        }
        
        switch mediaData[index].media_type {
        case "tv":
            guard let title = mediaData[index].name else { return }
            vc.webViewTitleString = title
        case "movie":
            guard let title = mediaData[index].title else { return }
            vc.webViewTitleString = title
        default:
            print("person?")
        }

        self.present(vc, animated: true, completion: nil)
    }
}
