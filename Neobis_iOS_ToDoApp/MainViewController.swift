//
//  MainViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by iPak Tulane on 31/10/23.
//


import UIKit

protocol TaskCellDelegate: AnyObject {
    func taskCellDidToggleDone(for cell: TaskTableViewCell)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

//    var taskItemsArray = [TaskItem]()
    var dataManager = DataManager.shared
    var isEditingMode = false
    var isNewMode = false
    
//    var selectedItem: TaskItem?
//    var index: Int?
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCellIdentifier")
        tableView.sectionFooterHeight = 100

//        tableView.rowHeight = UITableView.automaticDimension
//        if let savedData = UserDefaults.standard.object(forKey: UserDefaultsKeys.toDoList) as? Data,
//           let savedList = try? PropertyListDecoder().decode([TaskItem].self, from: savedData) {
//            taskItemsArray = savedList
//        }
        
        setupFloatingButtons()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Floating buttons
    func setupFloatingButtons() {
        editButton.layer.zPosition = 1
        addButton.layer.zPosition = 1
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Edit button
    @IBAction func editButtonTapped(_ sender: UIButton) {
        addButton.isHidden = !isEditingMode
        tableView.isEditing = !isEditingMode
        
        if isEditingMode {
            editButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        } else {
            editButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        }
        
        for cell in tableView.visibleCells {
            if let taskCell = cell as? TaskTableViewCell {
                taskCell.setEditingMode(!isEditingMode)
            }
        }
        isEditingMode.toggle()
    }
    
//    {
//        tableView.isEditing = !tableView.isEditing
//        sender.setTitle(tableView.isEditing ? "" : "", for: .normal)
//    }
    
    
    
    // MARK: - Add button
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        isNewMode = true
        
        let vc = UINavigationController(rootViewController: TaskViewController(task: TaskItem(title: "", description: "", isDone: false), isNewMode: true))
        present(vc, animated: true)
    }
}


//    {
//        performSegue(withIdentifier: "fromMainToTaskSegue", sender: self)
//    }
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier  == "fromMainToTaskSegue" {
//            if let destination = segue.destination as? TaskViewController {
//                if !isEditingMode {
//                    destination.callback = {
//                        if let savedData = UserDefaults.standard.object(forKey: UserDefaultsKeys.toDoList) as? Data,
//                           let savedList = try? PropertyListDecoder().decode([TaskItem].self, from: savedData) {
//                            self.taskItemsArray += savedList
//                        }
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                } else {
//                    destination.title = selectedItem?.title ?? ""
//                    destination.customDescription = selectedItem?.description ?? ""
//                    destination.isEditingMode = true
//                    destination.edit = { item in
//                        guard let index = self.index else { return }
//                        self.taskItemsArray[index] = item
//                        if let savedData = try? PropertyListEncoder().encode(self.taskItemsArray) {
//                            UserDefaults.standard.set(savedData, forKey: UserDefaultsKeys.toDoList)
//                        }
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                    isEditingMode = false
//                }
//            }
//        }
//    }
//}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return taskItemsArray.count
        return dataManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellIdentifier", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        
        cell.configureCell(title: dataManager.tasks[indexPath.row].title, descriptionText: dataManager.tasks[indexPath.row].description, isDone: dataManager.tasks[indexPath.row].isDone)
        return cell
    }

    
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
//        let taskItem = taskItemsArray[indexPath.row]
//        cell.textLabel?.text = taskItem.title
//        cell.detailTextLabel?.text = truncateDescription(taskItem.description)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataManager.tasks.count - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        isNewMode = false
        
        let task = TaskItem(
            title: dataManager.tasks[indexPath.row].title,
            description: dataManager.tasks[indexPath.row].description,
            isDone: dataManager.tasks[indexPath.row].isDone)
        let vc = UINavigationController(rootViewController: TaskViewController(task: task, isNewMode: false, index:indexPath.row))
//        vc.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.removeTask(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    {
//        tableView.beginUpdates()
//        taskItemsArray.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        tableView.endUpdates()
//    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataManager.moveTask(from: sourceIndexPath.row, into: destinationIndexPath.row)
    }
    
    func taskCellDidToggleDone(for cell: TaskTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataManager.toggleDone(index: indexPath.row, isDone: true)
            tableView.reloadRows(at: [indexPath], with: .none)
            dataManager.refreshData()
        }
    }
    
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let label = UILabel()
        label.text = "ToDoApp"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            let footerView = UIView()
            let label = UILabel()
            label.text = "Press (+) button to add a new task to the list."
            label.textAlignment = .center
            label.textColor = UIColor.gray
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 15.0)
            footerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func truncateDescription(_ description: String) -> String {
        let maxLength = 40
        if description.count > maxLength {
            let truncated = description.prefix(maxLength - 3) + "..."
            return String(truncated)
        }
        return description
    }
}

// MARK: - TaskViewControllerDelegate
//extension MainViewController: TaskViewControllerDelegate {
//    
//    func saveToDoItems(taskItem: TaskItem) {
//        guard !taskItem.title.isEmpty else {
//            return
//        }
//        taskItemsArray.append(taskItem)
//        tableView.reloadData()
//        
//        // Store title and description data in UserDefaults when a task is saved
//        UserDefaults.standard.set(taskItem.title, forKey: UserDefaultsKeys.titleDataKey)
//        UserDefaults.standard.set(taskItem.description, forKey: UserDefaultsKeys.descriptionDataKey)
//    }
//
//    func loadToDoItems() {
//        // Load title and description data from UserDefaults
//        if let titleData = UserDefaults.standard.string(forKey: UserDefaultsKeys.titleDataKey),
//           let descriptionData = UserDefaults.standard.string(forKey: UserDefaultsKeys.descriptionDataKey),
//           let isDoneData = UserDefaults.standard.string(forKey: UserDefaultsKeys.isDoneDataKey) {
//            let taskItem = TaskItem(title: titleData, description: descriptionData, isDone: isDoneData)
//            taskItemsArray.append(taskItem)
//            tableView.reloadData()
//        } else {
//            print("Error: Failed to load task data from UserDefaults.")
//        }
//    }
//}


