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

        // Create a UITapGestureRecognizer and add it to isDoneImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(isDoneImageViewTapped))
        isDoneImageView.addGestureRecognizer(tapGesture)
        isDoneImageView.isUserInteractionEnabled = true // Enable user interaction for the image view
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func isDoneImageViewTapped() {
        // Handle the tap gesture to change status of certain to-do item
        if isDoneImageView.image == UIImage(systemName: "circle") {
            isDoneImageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            isDoneImageView.image = UIImage(systemName: "circle")
        }
    }
    
}
