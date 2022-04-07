//
//  EditViewController.swift
//  MeMoMemo_StoryBoard
//
//  Created by Jaehoon So on 2022/04/07.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var memoNumber: Int = -1
    var memoes: [Memo]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMemo()
        
        titleTextField.text = memoes![memoNumber].title
        bodyTextView.text = memoes![memoNumber].body
        // Do any additional setup after loading the view.
    }
    
    func fetchMemo() {
        do {
            self.memoes = try context.fetch(Memo.fetchRequest())
        } catch {
            
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
