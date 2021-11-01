//
//  MovieTableViewCell.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/15.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: Property
    
    static let identifier = "MovieTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var engTitle: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var korTitle: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var linkButton: UIButton!
    
    var linkButtonDelegate: LinkButtonDelegate?
    
    var index: Int = 0
    
    //MARK: Method
    
    @IBAction func linkButtonClicked(_ sender: UIButton) {
        
        if let delegate = linkButtonDelegate {
            delegate.linkButtonClicked(index: index)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
