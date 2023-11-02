//
//  TaskViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 01/11/23.
//

import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func saveToDoItems(taskItem: TaskItem)
    func loadToDoItems()
}

class TaskViewController: UIViewController {
    
    var taskItem: TaskItem?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    weak var delegate: TaskViewControllerDelegate?
    
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap taskItem safely
        if let taskItem = taskItem {
            delegate?.saveToDoItems(taskItem: taskItem)
            
            if let titleData = UserDefaults.standard.string(forKey: "TitleDataKey"),
               let descriptionData = UserDefaults.standard.string(forKey: "DescriptionDataKey") {
                // Populate your UI elements with the loaded data
                titleTextField.text = titleData
                descriptionTextView.text = descriptionData
            }
        } else {
            print("Error: TaskItem is nil in viewDidLoad.")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let titleData = titleTextField.text ?? ""
        let descriptionData = descriptionTextView.text ?? ""

        let taskItem = TaskItem(title: titleData, description: descriptionData, isDone: false, positionOnList: 0)
        
        // Save the data to UserDefaults
        UserDefaults.standard.set(titleData, forKey: "TitleDataKey")
        UserDefaults.standard.set(descriptionData, forKey: "DescriptionDataKey")
        
        // Save the task using the delegate's method
        delegate?.saveToDoItems(taskItem: taskItem)
                
        // Dismiss the second view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
