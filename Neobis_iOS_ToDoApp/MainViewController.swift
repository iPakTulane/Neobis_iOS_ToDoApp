//
//  MainViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 31/10/23.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var tasks: [TaskItem] = [
        TaskItem(title: "Task 1", description: "To make shopping", positionOnList: 0),
        TaskItem(title: "Task 2", description: "To clean dishes", positionOnList: 1),
        TaskItem(title: "Task 3", description: "To walk a dog", positionOnList: 2),
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButtonsViews()
    }
    
    func setupButtonsViews() {
        editButton.layer.zPosition = 1
        addButton.layer.zPosition = 1
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    

    @IBAction func editButtonTapped(_ sender: UIButton) {
        addButton.isHidden = true
        editButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
    }
    
    
}



