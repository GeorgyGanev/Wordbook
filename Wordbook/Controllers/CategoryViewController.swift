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
    
    //MARK: - Add New Wordbook Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Language", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newWordbook = Wordbook(context: self.context)
            newWordbook.name = textField.text
            self.wordbookArray.append(newWordbook)
            self.saveWordbook()
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
