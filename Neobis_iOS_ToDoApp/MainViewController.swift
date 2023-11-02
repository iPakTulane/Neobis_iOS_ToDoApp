//
//  MainViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 31/10/23.
//

import UIKit

class MainViewController: UIViewController {
    
    var taskItem: TaskItem?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var tasks: [TaskItem] = []
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData() // Reload the data immediately
        setupButtonsViews()
        // Load the task data when the view loads
        loadToDoItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // Reload the data when the view appears
    }
    
    
    func setupButtonsViews() {
        editButton.layer.zPosition = 1
        addButton.layer.zPosition = 1
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Buttons
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        addButton.isHidden = true
        editButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "fromMainToTaskSegue", sender: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let taskViewController = storyboard.instantiateViewController(withIdentifier: "TaskViewControllerIdentifier") as! TaskViewController
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print("Selected item: \(tasks[indexPath.row])")
        
        let selectedTask = tasks[indexPath.row]
        
        // Perform the segue to show the second view controller
        performSegue(withIdentifier: "fromMainToTaskSegue", sender: selectedTask)
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMainToTaskSegue" {
            if let selectedTask = sender as? TaskItem, let destinationVC = segue.destination as? TaskViewController {
                // Pass the selected task's data to the TaskViewController
                destinationVC.taskItem = selectedTask
            }
        }
    }
}

// MARK: - TaskViewControllerDelegate

extension MainViewController: TaskViewControllerDelegate {
    func saveToDoItems(taskItem: TaskItem) {
        // Implement your save logic here
        UserDefaults.standard.set(taskItem.title, forKey: UserDefaultsKeys.titleDataKey)
        UserDefaults.standard.set(taskItem.description, forKey: UserDefaultsKeys.descriptionDataKey)
        UserDefaults.standard.set(taskItem.isDone, forKey: UserDefaultsKeys.isDoneDataKey)
        UserDefaults.standard.set(taskItem.positionOnList, forKey: UserDefaultsKeys.positionOnListDataKey)
    }
    
    func loadToDoItems() {
        // Implement your load logic here
        if let titleData = UserDefaults.standard.string(forKey: UserDefaultsKeys.titleDataKey),
           let descriptionData = UserDefaults.standard.string(forKey: UserDefaultsKeys.descriptionDataKey) {
            let taskItem = TaskItem(title: titleData, description: descriptionData, isDone: false, positionOnList: 0)
            
            // Append the loaded taskItem to your tasks array
            tasks.append(taskItem)
            
            // Reload the table view to display the new data
            tableView.reloadData()
        }
        
        else {
            print("Error: Failed to load task data from UserDefaults.")
        }
    }
}



