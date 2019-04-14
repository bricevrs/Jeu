//
//  ScoresViewController.swift
//  Jeu
//
//  Created by virassamy brice on 14/04/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

import UIKit

class ScoresViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structScore.tabScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellScore",for: indexPath) as! cellTableView
        cell.pseudo.text = structScore.tabScore[indexPath.row].0
        cell.score.text = String(structScore.tabScore[indexPath.row].1)
        //rajouter date
        cell.tableView=tableView
        return cell
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
