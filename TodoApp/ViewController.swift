//
//  ViewController.swift
//  TodoApp
//
//  Created by ozelot on 2020/02/27.
//  Copyright © 2020 nhs70060. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todolist = [Todo]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodolist()
    }
    
    @IBAction func AddButton(_ sender: Any) {
        let alert = UIAlertController(title: "追加", message: "タスクを入力してください", preferredStyle: .alert)

        alert.addTextField(configurationHandler: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            if let textField = alert.textFields?.first {
                let todo = Todo(title: textField.text!)
                self.todolist.insert(todo, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                self.saveTodolist()
            }
        }
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = todolist[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.done ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todolist[indexPath.row]
        todo.done = !todo.done
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        saveTodolist()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todolist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTodolist()
        }
    }

    private func loadTodolist() {
        if let storedData = UserDefaults().data(forKey: "todolist") {
            do {
                let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData)
                todolist.append(contentsOf: unarchivedData as! [Todo])
            } catch {
                print(error)
            }
        }
    }

    private func saveTodolist() {
        let userDefaults = UserDefaults.standard
        do {
            let archivedData: Data = try NSKeyedArchiver.archivedData(withRootObject: todolist, requiringSecureCoding: false)
            userDefaults.set(archivedData, forKey: "todolist")
            userDefaults.synchronize()
        } catch {
            print(error)
        }
    }

}
