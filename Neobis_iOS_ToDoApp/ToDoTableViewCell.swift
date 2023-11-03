//
//  ToDoTableViewCell.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 03/11/23.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var isDoneImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
