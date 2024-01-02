//
//  CategoryViewController.swift
//  Wordbook
//
//  Created by Georgy Ganev on 2.01.24.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var wordbookArray = [Wordbook]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWordbooks()
    }

    // MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordbookArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordbookCell", for: indexPath)
        cell.textLabel?.text = wordbookArray[indexPath.row].name
        return cell
    }
 
    
    //MARK: - TableView Data Manipulation Methods
    
    func saveWordbook() {
        do {
            try context.save()
        } catch {
            print("error saving new wordbook: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func deleteWordbook(at index: Int) {
        context.delete(wordbookArray[index])
        wordbookArray.remove(at: index)
        saveWordbook()
    }
    
    func loadWordbooks () {
        let request: NSFetchRequest<Wordbook> = Wordbook.fetchRequest()
        do {
            try wordbookArray = context.fetch(request)
        } catch {
            print("error loading wordbooks: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    //MARK: - TableVIew Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteWordbook(at: indexPath.row)
        }
    }
    
    //MARK: - Add New Wordbook Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Language", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != "" {
                let newWordbook = Wordbook(context: self.context)
                newWordbook.name = textField.text
                self.wordbookArray.append(newWordbook)
                self.saveWordbook()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Language"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
