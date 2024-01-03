//
//  DefinitionViewController.swift
//  Wordbook
//
//  Created by Georgy Ganev on 3.01.24.
//

import UIKit
import CoreData

class DefinitionViewController: UIViewController, UITextViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var wordLable: UILabel!
    @IBOutlet weak var definitionView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var wordItem: WordItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definitionView.delegate = self
        saveButton.isHidden = true
        wordLable.text = wordItem.title
        definitionView.text = wordItem.definition ?? ""
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isHidden = false
        definitionView.text = textView.text
    }
        
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
       
        wordItem.definition = definitionView.text
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        sender.self.isHidden = true
        
        definitionView.resignFirstResponder()
    }
    
}

