//
//  FeedCell.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var dinnerNameLabel: UILabel!
    @IBOutlet weak var dinnerCategoryLabel: UILabel!
    @IBOutlet weak var dinnerImageLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
