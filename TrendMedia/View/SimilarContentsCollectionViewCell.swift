//
//  SimilarContentsCollectionViewCell.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/31.
//

import UIKit

class SimilarContentsCollectionViewCell: UICollectionViewCell {

    static let identifier = "SimilarContentsCollectionViewCell"
    
    //MARK: UI
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.genresLabel.text = ""
    }
    

}
