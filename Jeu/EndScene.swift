//
//  EndScene.swift
//  Jeu
//
//  Created by virassamy brice on 08/04/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

import SpriteKit

let mainMenu = SKScene(fileNamed: "MainMenu")

class EndScene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("iencli")

        //view?.presentScene(mainMenu!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
    }
}
