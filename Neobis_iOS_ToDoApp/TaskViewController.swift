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
        
        setupTextView()
        setupTextField()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let titleData = titleTextField.text ?? "Title"
        let descriptionData = descriptionTextView.text ?? "Description"

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

extension TaskViewController: UITextViewDelegate {
    
    func setupTextView() {
        // Set the placeholder text for descriptionTextView
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.font = .systemFont(ofSize: 15)
        // Set the delegate for descriptionTextView
        descriptionTextView.delegate = self
        
        // Customize the appearance of the descriptionTextView
        descriptionTextView.layer.borderWidth = 1.0 // Border width
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor // Border color
        descriptionTextView.layer.cornerRadius = 5.0 // Corner radius (for rounded corners)
        descriptionTextView.clipsToBounds = true // Ensure the border doesn't exceed the bounds
    }
    
    func setupTextField() {
        // Set the placeholder text for titleTextField
        titleTextField.text = "Title"
        titleTextField.textColor = UIColor.lightGray
        titleTextField.font = .systemFont(ofSize: 15)
        
        // Customize the appearance of the descriptionTextView
        titleTextField.layer.borderWidth = 1.0 // Border width
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor // Border color
        titleTextField.layer.cornerRadius = 5.0 // Corner radius (for rounded corners)
        titleTextField.clipsToBounds = true // Ensure the border doesn't exceed the bounds
        
    }
    
    
    
    // UITextViewDelegate method to clear placeholder text when editing starts
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.black // Set the text color to black or your preferred color
        }
    }
    
}
