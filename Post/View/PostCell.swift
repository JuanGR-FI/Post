//
//  PostCell.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var idLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
