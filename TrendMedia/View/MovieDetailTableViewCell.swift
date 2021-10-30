//
//  MovieDetailTableViewCell.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/16.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var story: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
