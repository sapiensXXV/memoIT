//
//  AddMemoViewController.swift
//  MeMoMemo_StoryBoard
//
//  Created by Jaehoon So on 2022/04/07.
//

import UIKit

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
            memoes = try! context.fetch(Memo.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let newMemo = Memo(context: self.context)
        newMemo.title = memoTitleTextField.text
        newMemo.body = memoBodyTextView.text
        newMemo.date = Date()
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        if newMemo.title == "" {
            let alert = UIAlertController(title: "제목을 입력해주세요",
                                          message: "제목을 한글자 이상 입력해주세요",
                                          preferredStyle: .alert)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else if newMemo.body == "" {
            let alert = UIAlertController(title: "내용이 입력되지 않았어요!",
                                          message: "본문을 입력해주세요",
                                          preferredStyle: .alert)
            alert.addAction(okButton)
        } else {
            do {
                try! self.context.save()
                print("저장되었습니다~")
            } catch {
                
            }
            self.fetchMemo()
            navigationController?.popViewController(animated: true)
//            dismiss(animated: true, completion: nil)
        }
    }

}
