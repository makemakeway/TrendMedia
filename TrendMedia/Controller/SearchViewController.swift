//
//  SearchViewController.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class SearchViewController: UIViewController {
    
    
    //MARK: Property
    
    var searchTimer: Timer?
    var startPage = 1 {
        didSet {
            print("current Page = \(startPage)")
        }
    }
    var totalPage = 0
    
    var mediaData = [MovieModel]() {
        didSet {
            print("mediaData Count: \(mediaData.count)")
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Method
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarConfig() {
        searchBar.searchTextField.borderStyle = .none
        searchBar.backgroundImage = UIImage()
        searchBar.layer.cornerRadius = 10
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
    }
    
    func fetchMovieData() {
        
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            makeAlert(title: nil, message: "검색하고 싶은 영화를 입력해주세요.", buttonTitle1: "확인")
            return
        }
        
        MovieAPIManager.shared.fetchSearchResult(searchText: searchText, page: startPage) {
            self.totalPage = $0["total_pages"].intValue
            let results = $0["results"].arrayValue
            results.forEach({
                if $0["media_type"].stringValue == "tv" || $0["media_type"].stringValue == "movie" {
                    let result = MovieModel(id: $0["id"].intValue,
                                            title: $0["title"].stringValue,
                                            original_language: $0["original_language"].stringValue,
                                            release_date: $0["release_date"].stringValue,
                                            first_air_date: $0["first_air_date"].stringValue,
                                            overview: $0["overview"].stringValue,
                                            original_title: $0["original_title"].stringValue,
                                            genre_ids: [],
                                            media_type: $0["media_type"].stringValue,
                                            poster_path: $0["poster_path"].stringValue,
                                            backdrop_path: $0["backdrop_path"].stringValue,
                                            origin_country: [],
                                            name: $0["name"].stringValue,
                                            original_name: $0["original_name"].stringValue)
                    self.mediaData.append(result)
                }
                
            })
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        
    }
    
    func makeAlert(title: String?, message: String?, buttonTitle1: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle1, style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfig()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.backgroundColor = UIColor(named: "AccentColor")
        
        searchBar.delegate = self
        
        let gesture = UITapGestureRecognizer()
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
}

//MARK: Extension
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailTableViewCell", for: indexPath) as? MovieDetailTableViewCell else {
            return UITableViewCell()
        }
    
        let movie = mediaData[indexPath.row]
        
        DispatchQueue.main.async {
            switch movie.media_type {
            case "movie":
                cell.title.text = "\(movie.title!)(\(movie.original_title!))"
                cell.releaseDate.text = movie.release_date! + " | "  + "\(movie.original_language!)"
            case "tv":
                cell.title.text = "\(movie.name!)(\(movie.original_name!))"
                cell.releaseDate.text = movie.first_air_date! + " | "  + "\(movie.original_language!)"
            default:
                print("error")
            }
            
            cell.title.textColor = .white
            cell.poster.kf.setImage(with: URL(string: EndPoint.MEDIA_IMAGE_URL + movie.poster_path), placeholder: UIImage(systemName: "star"))
            cell.poster.backgroundColor = .black
            cell.story.text = movie.overview
            cell.backgroundColor = UIColor(named: "AccentColor")
            cell.selectionStyle = .none
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.height * 0.2
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath)
        return nil
    }
    
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({
            if $0.row == self.mediaData.count - 1 && self.startPage < self.totalPage {
                self.startPage += 1
                print("fetch new page")
                fetchMovieData()
            }
        })
    }
}

//MARK: SearchBar delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 텍스트를 입력했다가 모두 지웠을 떄, 타이머 무효화
        if searchBar.text!.isEmpty {
            self.searchTimer?.invalidate()
            return
        }
        
        // 타이핑을 계속 입력할 수 있으므로, 타이머를 무효화 시키고 새로운 타이머를 맞춰준다.
        self.searchTimer?.invalidate()
        self.searchTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
            self.mediaData.removeAll()
            self.startPage = 1
            self.fetchMovieData()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 서치바에서 리턴을 한 경우이므로, 현재 모든 데이터들을 지워주고 페이지를 첫 페이지로 바꾼 뒤, 새롭게 데이터를 받는다.
        self.mediaData.removeAll()
        self.startPage = 1
        fetchMovieData()
    }
    
}

//MARK: gesture Recogniger delegate
extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !touch.view!.isDescendant(of: searchBar) {
            self.searchBar.resignFirstResponder()
            return false
        }
        return false
    }
}
