//
//  ItemsViewController.swift
//  Wordbook
//
//  Created by Georgy Ganev on 2.01.24.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController {
    
    var parentCategory: Wordbook? {
        didSet {
            loadWordItems()
        }
    }
    
    var wordItemsArray = [WordItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordItemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordItemCell", for: indexPath)
        cell.textLabel?.text = wordItemsArray[indexPath.row].title
        return cell
    }


    //MARK: - TableView Data Manipulation Methods
    
    func loadWordItems(with request: NSFetchRequest<WordItem> = WordItem.fetchRequest(), predicate: NSPredicate? = nil) {
      
        let wordbookPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, wordbookPredicate])
        } else {
            request.predicate = wordbookPredicate
        }
        
        
        do {
           try wordItemsArray = context.fetch(request)
        } catch {
            print("error loading word items: \(error.localizedDescription)")
        }
        tableView.reloadData()
        
    }
    
    func saveWordItem() {
        do {
            try context.save()
        } catch {
            print("error saving new word item: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
        
    //MARK: - Add New WordItem
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var titleTextField = UITextField()
        var definitionTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Word", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Word"
            titleTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Definition"
            definitionTextField = alertTextField
        }
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if let title = titleTextField.text, let definition = definitionTextField.text {
                let newWord = WordItem(context: self.context)
                newWord.title = title
                newWord.definition = definition
                newWord.parentCategory = self.parentCategory
                self.wordItemsArray.append(newWord)
                self.saveWordItem()
            
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
        
    }
    
    //MARK: - WordItem Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDefinition", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DefinitionViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.word = wordItemsArray[indexPath.row].title!
            destinationVC.definition = wordItemsArray[indexPath.row].definition!
            
        }
        
    }

}


//MARK: - Search Methods

extension ItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {return}
        
        let request: NSFetchRequest<WordItem> = WordItem.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        loadWordItems(with: request, predicate: predicate)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadWordItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

