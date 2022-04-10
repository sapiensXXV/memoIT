//
//  ViewController.swift
//  MeMoMemo_StoryBoard
//
//  Created by Jaehoon So on 2022/04/04.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMemoLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var memoes: [Memo]? = nil
    var selectedRow: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        
        tableView.register(nib, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor(named: Constant.Color.memoViewColor)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 70
        
        fetchMemo()
        
        if memoes!.count == 0 {
            noMemoLabel.text = "작성된 메모가 없습니다"
        } else {
            noMemoLabel.text = ""
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMemo()
        if memoes!.count == 0 {
            noMemoLabel.text = "작성된 메모가 없습니다"
        } else {
            noMemoLabel.text = ""
        }
    }
    
    func fetchMemo() {
        do {
            let request = Memo.fetchRequest() as! NSFetchRequest<Memo>      
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            memoes = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToEdit" {
            let destinationVC = segue.destination as! EditViewController
            destinationVC.memoNumber = selectedRow
        }
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memoes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoTableViewCell
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let time = memoes![indexPath.row].date else { return cell }
        let formattedString = dateFormatter.string(from: time)
        
        cell.memoDateLabel.text = formattedString
        cell.memoTitleLabel.text = memoes![indexPath.row].title
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    //셀이 선택되었으 때 편집 뷰로 이동(EditViewController)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        //withIdentifier: segue의 identifier 이름
        //sender: 누가 segue의 시작점인가?
        self.performSegue(withIdentifier: "MainToEdit", sender: self)
    
    }
    
}

