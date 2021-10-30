//
//  StoryTableViewCell.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/19.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    
    //MARK: Property
    
    static let identifier = "StoryTableViewCell"
    
    var delegate: SpreadButtonDelegate?
    
    @IBOutlet weak var storyLabel: UILabel!
    
    @IBOutlet weak var spreadButton: UIButton!
    
    @IBAction func spreadButtonClicked(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.spreadAndFold()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
