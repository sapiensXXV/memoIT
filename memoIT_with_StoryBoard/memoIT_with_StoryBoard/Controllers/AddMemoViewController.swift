//
//  AddMemoViewController.swift
//  MeMoMemo_StoryBoard
//
//  Created by Jaehoon So on 2022/04/07.
//

import UIKit
import CoreData

class AddMemoViewController: UIViewController {
    @IBOutlet weak var memoTitleTextField: UITextField!
    @IBOutlet weak var memoBodyTextView: UITextView!
    
    var memoes: [Memo]?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchMemo()
    }
    
    
    func fetchMemo() {
        do {
            let request = Memo.fetchRequest() as! NSFetchRequest<Memo>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            memoes = try context.fetch(request)
            
        } catch {
            
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        if memoTitleTextField.text == "" {
            activateDefaultAlert(title: "제목이 입력되지 않았습니다",
                                 message: "제목을 입력해주세요",
                                 alertAction: okButton)
        } else if memoBodyTextView.text == "" {
            activateDefaultAlert(title: "내용이 입력되지 않았습니다",
                                 message: "내용을 입력해주세요",
                                 alertAction: okButton)
        } else {
            let newMemo = Memo(context: self.context)
            newMemo.title = memoTitleTextField.text
            newMemo.body = memoBodyTextView.text
            newMemo.date = Date()
            do {
                try! self.context.save()
                print("저장되었습니다~")
            } catch {
                print(error)
            }
            self.fetchMemo()
            navigationController?.popViewController(animated: true)
        }
    }
    
    //기본 알림 생성->실행
    func activateDefaultAlert(title: String, message: String, alertAction: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let action = alertAction {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
