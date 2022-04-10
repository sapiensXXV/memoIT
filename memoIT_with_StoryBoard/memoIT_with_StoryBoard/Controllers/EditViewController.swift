//
//  EditViewController.swift
//  MeMoMemo_StoryBoard
//
//  Created by Jaehoon So on 2022/04/07.
//

import UIKit
import CoreData

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
    
    //MARK: - 메모 리로드
    func fetchMemo() {
        do {
            let request = Memo.fetchRequest() as! NSFetchRequest<Memo>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            memoes = try context.fetch(request)
 
        } catch {
            
        }
    }
    
    //MARK: - 메모 저장
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        memoes![memoNumber].title = titleTextField.text!
        memoes![memoNumber].body = bodyTextView.text! 
        
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - 메모 삭제
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "메모 삭제", message: "메모를 삭제하시겠습니까?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "네", style: .default) { UIAlertAction in
            let memoToRemove = self.memoes![self.memoNumber]
            do {
                self.context.delete(memoToRemove)
                try self.context.save()
            } catch {
                print(error)
            }
            self.fetchMemo()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelButton = UIAlertAction(title: "아니오", style: .destructive)
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
