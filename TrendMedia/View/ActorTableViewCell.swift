//
//  ActorTableViewCell.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/16.
//

import UIKit

class ActorTableViewCell: UITableViewCell {
    
    
    //MARK: Property
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var role: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
