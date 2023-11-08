//
//  TaskTableViewCell.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 08/11/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var isDoneButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    
    var isDone: Bool = false
    weak var delegate: TaskCellDelegate?
    var isEditingMode = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func isDoneButtonTapped(_ sender: Any) {
                
        if !isDone {
            isDoneButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            isDoneButton.currentImage?.withTintColor(.systemGreen)
            isDone = true
        } else {
            isDoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
            isDoneButton.currentImage?.withTintColor(.systemOrange)
            isDone = false
        }
        delegate?.taskCellDidToggleDone(for: self)
    }
    
    
    
    func setEditingMode(_ isEditing: Bool) {
        isEditingMode = isEditing
//        detailsButton.isHidden = isEditing
    }
    
    func configureCell(task: TaskItem) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        isDone = task.isDone
    }
    
    func configureCell(title: String, descriptionText: String, isDone: Bool) {
        titleLabel.text = title
        descriptionLabel.text = descriptionText
        self.isDone = isDone
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
