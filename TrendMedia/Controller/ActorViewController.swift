//
//  ActorViewController.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/16.
//

import UIKit
import Kingfisher
import MapKit
import SwiftyJSON

class ActorViewController: UIViewController {

    
    
    //MARK: Property
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var opacityView: UIView!
    
    var movieInfo: MovieModel?
    
    var casts = [Actor]()
    var crews = [Crew]()
    
    var spreaded: Bool = false
    
    lazy var backButtonCustomView: UIButton = {
        
        var configure = UIButton.Configuration.plain()
        configure.title = "뒤로"
        configure.image = UIImage(systemName: "chevron.left")
        configure.imagePadding = 5
        configure.baseForegroundColor = .label
        
        let button = UIButton(configuration: configure, primaryAction: nil)
        button.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(customView: backButtonCustomView)
        return button
    }()
    
    
    //MARK: Method
    
    func fetchHeaderView() {
        guard let data = movieInfo else {
            print("movie data missing")
            return
        }
        
        guard let backgroundPosterImagePathUrl = URL(string: EndPoint.MEDIA_IMAGE_URL + data.backdrop_path), let posterImagePathUrl = URL(string: EndPoint.MEDIA_IMAGE_URL + data.poster_path) else {
            print("URL 변환 실패")
            return
        }
        guard let name = data.name , let title = data.title else {
            print("data에 이름이 없습니다.")
            return
        }

        switch self.movieInfo?.media_type {
        case "movie":
            self.movieTitle.text = title
        case "tv":
            self.movieTitle.text = name
        default:
            self.movieTitle.text = title
        }
        
        movieBackgroundImageView.kf.setImage(with: backgroundPosterImagePathUrl)
        posterImageView.kf.setImage(with: posterImagePathUrl)
    }
    
    func fetchMovieCreditData() {
        guard let movieInfo = movieInfo else {
            print("no data")
            return
        }

        MovieAPIManager.shared.fetchMovieCredit(category: movieInfo.media_type, id: movieInfo.id) { code, json in
            
            let actors = json["cast"].arrayValue
            let crews = json["crew"].arrayValue
            
            for actor in actors {
                let actor = Actor(id: actor["id"].intValue,
                                 name: actor["name"].stringValue,
                                 image: actor["profile_path"].stringValue,
                                 character: actor["character"].stringValue,
                                 credit_id: actor["credit_id"].stringValue)
                self.casts.append(actor)
            }
            for crew in crews {
                let crew = Crew(id: crew["id"].intValue,
                                name: crew["name"].stringValue,
                                profile_path: crew["profile_path"].stringValue,
                                job: crew["job"].stringValue,
                                credit_id: crew["credit_id"].stringValue)
                self.crews.append(crew)
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    func headerOpacityConfig() {
        opacityView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
    }
    
    @objc func backButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "출연/제작"
        self.navigationItem.leftBarButtonItem = backButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: StoryTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: StoryTableViewCell.identifier)
        
        fetchMovieCreditData()
    
        
        fetchHeaderView()
        movieTitle.textColor = .white
        movieBackgroundImageView.contentMode = .scaleAspectFill
        headerOpacityConfig()
        
    }
    
}


//MARK: TableView Delegate
extension ActorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return self.casts.count
        case 2:
            return self.crews.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.identifier, for: indexPath) as? StoryTableViewCell else { return UITableViewCell() }
            cell.storyLabel.text = movieInfo?.overview
            cell.delegate = self
            let image = spreaded == true ? "chevron.up" : "chevron.down"
            cell.spreadButton.setImage(UIImage(systemName: image), for: .normal)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorTableViewCell", for: indexPath) as? ActorTableViewCell else {
                return UITableViewCell()
            }
            
            let data = self.casts[indexPath.row]
            cell.name.text = data.name
            cell.name.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

            cell.role.text = data.character
            cell.role.font = UIFont.systemFont(ofSize: 14)
            cell.role.textColor = .gray

            cell.profileImage.kf.setImage(with: URL(string: EndPoint.MEDIA_IMAGE_URL + data.image))
            cell.profileImage.backgroundColor = .label
            cell.profileImage.layer.cornerRadius = 10
            
            cell.selectionStyle = .none
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorTableViewCell", for: indexPath) as? ActorTableViewCell else {
                return UITableViewCell()
            }
            
            let data = self.crews[indexPath.row]
            cell.name.text = data.name
            cell.name.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

            cell.role.text = data.job
            cell.role.font = UIFont.systemFont(ofSize: 14)
            cell.role.textColor = .gray

            cell.profileImage.kf.setImage(with: URL(string: EndPoint.MEDIA_IMAGE_URL + data.profile_path))
            cell.profileImage.backgroundColor = .label
            cell.profileImage.layer.cornerRadius = 10
            
            cell.selectionStyle = .none
            
            return cell
        default:
            print("default")
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 원하는 것이 줄거리 섹션의 높이를 조절하는 것이기 때문에 조건을 제한
        if indexPath.section == 0 && spreaded {
            return UITableView.automaticDimension
        }
        
        return UIScreen.main.bounds.height * 0.125
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath)
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "배우"
        case 2:
            return "제작진"
        default:
            return "오류"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 44
        case 2:
            return 44
        default:
            return 0
        }
    }
    
}


extension ActorViewController: SpreadButtonDelegate {
    func spreadAndFold() {
        spreaded.toggle()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
}
