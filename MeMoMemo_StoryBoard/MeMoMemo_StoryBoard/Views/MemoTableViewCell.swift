//
//  MemoViewCellTableViewCell.swift
//  MeMoMemo_StoryBoard
//
//  Created by Jaehoon So on 2022/04/07.
//

import UIKit
import CoreData


class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoDateLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
