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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var taskItems = [TaskItem]()
    var callback: (() -> ())?
    var edit: ((TaskItem) -> ())?
    var toEdit = false
    
    var customTitle = ""
    var customDescription = ""
    
    weak var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = customTitle
        descriptionTextView.text = customDescription
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        setupTextField()
        setupTextView()
        loadSavedDataFromUserDefaults()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let titleData = titleTextField.text ?? ""
        let descriptionData = descriptionTextView.text ?? ""
        
        if !toEdit {
            let newItem = TaskItem(title: titleData, description: descriptionData)
            taskItems.append(newItem)
            saveToDoItems()
        } else {
            let editedItem = TaskItem(title: titleData, description: descriptionData)
            edit?(editedItem)
            toEdit = false
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveToDoItems() {
        if !toEdit {
            if let savedData = try? PropertyListEncoder().encode(taskItems) {
                UserDefaults.standard.set(savedData, forKey: UserDefaultsKeys.toDoList)
                UserDefaults.standard.set(titleTextField.text, forKey: UserDefaultsKeys.titleDataKey)
                UserDefaults.standard.set(descriptionTextView.text, forKey: UserDefaultsKeys.descriptionDataKey)
                callback?()
            }
        }
    }
    
    func loadSavedDataFromUserDefaults() {
        if let titleData = UserDefaults.standard.string(forKey: UserDefaultsKeys.titleDataKey),
           let descriptionData = UserDefaults.standard.string(forKey: UserDefaultsKeys.descriptionDataKey) {
            titleTextField.text = titleData
            descriptionTextView.text = descriptionData
        }
    }
    
}

extension TaskViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func setupTextField() {
        titleTextField.delegate = self
        titleTextField.placeholder = "Title"
        titleTextField.textColor = UIColor.lightGray
        titleTextField.font = .systemFont(ofSize: 15)
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.clipsToBounds = true
    }
    
    func setupTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.font = .systemFont(ofSize: 15)
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.clipsToBounds = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleTextField.placeholder = nil
        textField.textColor = UIColor.black
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}
