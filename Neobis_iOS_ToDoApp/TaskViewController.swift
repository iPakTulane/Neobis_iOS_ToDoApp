//
//  TaskViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 01/11/23.
//


import UIKit

//protocol TaskViewControllerDelegate: AnyObject {
//    func saveToDoItems(taskItem: TaskItem)
//    func loadToDoItems()
//}

class TaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var dataManager = DataManager.shared
    var isNewMode: Bool = true
    var task: TaskItem?
    var index: Int?

//    var taskItems = [TaskItem]()
//    var callback: (() -> ())?
//    var edit: ((TaskItem) -> ())?
//    var isEditingMode = false
    
    
    init(task: TaskItem, isNewMode: Bool, index: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.isNewMode = isNewMode
        self.index = index
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    var customTitle = ""
//    var customDescription = ""
//    
//    weak var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleTextField.text = customTitle
//        descriptionTextView.text = customDescription
//        descriptionTextView.textContainerInset = UIEdgeInsets.zero
//        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        setupTextField()
        setupTextView()
        
        titleTextField.text = task?.title
        descriptionTextView.text = task?.description
                
//        loadSavedDataFromUserDefaults()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if self.isNewMode{
            DataManager.shared.tasks.append(TaskItem(
                title: titleTextField.text ?? "",
                description: descriptionTextView.text,
                isDone: false))
        } else {
            if let i = index {
                DataManager.shared.tasks[i] = TaskItem(
                    title: titleTextField.text ?? "",
                    description: descriptionTextView.text,
                    isDone: task?.isDone ?? false)
            }
        }
        dataManager.refreshData()
        dismiss(animated: true)
    }
    
    
    
    
    
//    {
//        let titleData = titleTextField.text ?? ""
//        let descriptionData = descriptionTextView.text ?? ""
//        var isDoneData = false
//        
//        if !isEditingMode {
//            let newItem = TaskItem(title: titleData, description: descriptionData, isDone: isDoneData)
//            taskItems.append(newItem)
//            saveToDoItems()
//        } else {
//            let editedItem = TaskItem(title: titleData, description: descriptionData, isDone: isDoneData)
//            edit?(editedItem)
//            isEditingMode = false
//        }
//        
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    func saveToDoItems() {
//        if !isEditingMode {
//            if let savedData = try? PropertyListEncoder().encode(taskItems) {
//                UserDefaults.standard.set(savedData, forKey: UserDefaultsKeys.toDoList)
//                UserDefaults.standard.set(titleTextField.text, forKey: UserDefaultsKeys.titleDataKey)
//                UserDefaults.standard.set(descriptionTextView.text, forKey: UserDefaultsKeys.descriptionDataKey)
//                callback?()
//            }
//        }
//    }
    
//    func loadSavedDataFromUserDefaults() {
//        if let titleData = UserDefaults.standard.string(forKey: UserDefaultsKeys.titleDataKey),
//           let descriptionData = UserDefaults.standard.string(forKey: UserDefaultsKeys.descriptionDataKey) {
//            titleTextField.text = titleData
//            descriptionTextView.text = descriptionData
//        }
//    }
    
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

