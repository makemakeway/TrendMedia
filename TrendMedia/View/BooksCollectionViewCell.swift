//
//  BooksCollectionViewCell.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/19.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {

    static let identifier = "BooksCollectionViewCell"
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
