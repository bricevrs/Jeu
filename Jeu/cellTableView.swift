//
//  cellTableView.swift
//  Jeu
//
//  Created by virassamy brice on 14/04/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

import UIKit

class cellTableView:UITableViewCell{
    @IBOutlet weak var pseudo:UILabel!
    @IBOutlet weak var score:UILabel!
    @IBOutlet weak var date:UILabel!
    
    var tableView:UITableView!
    
    @IBAction func del(_ sender:Any){
        for i in 0...structScore.tabScore.count-1{
            if (structScore.tabScore[i].0==pseudo.text && structScore.tabScore[i].1==Int(score.text!)){
                structScore.tabScore.remove(at: i)
                tableView.reloadData()
                return
            }
        }
    }
}
