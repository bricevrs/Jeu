//
//  EndGameViewController.swift
//  Jeu
//
//  Created by virassamy brice on 14/04/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

import UIKit


class EndGameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBOutlet weak var pseudo: UITextField!
    
    @IBAction func save(_ sender: Any) {
        
        structScore.tabScore.append((pseudo.text!, structScore.currentScore))
        
        
    }
}
