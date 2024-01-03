//
//  DefinitionViewController.swift
//  Wordbook
//
//  Created by Georgy Ganev on 3.01.24.
//

import UIKit

class DefinitionViewController: UIViewController {
    
    @IBOutlet weak var wordLable: UILabel!
    @IBOutlet weak var definitionView: UITextView!
    
    var word: String = ""
    var definition: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLable.text = word
        definitionView.text = definition
        
    }

}
