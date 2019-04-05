//
//  GameScene.swift
//  Jeu
//
//  Created by virassamy brice on 28/03/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var nbRandom:Int = 0
    private var nbe:Int = 1
    
    //perso
    private var perso = SKSpriteNode()
    private var hitting:Bool = false
    private var life:Int = 15
    private var score:Int = 0
    
    
    //saut
    private let saut:CGVector = CGVector(dx: 0, dy: 400)
    
    
    //Physique de la scène
    private var bgVelocity:CGFloat = 5.0
    private var enemyVelocity:CGFloat = 4.0
    private var gravity:CGVector = CGVector(dx: 0, dy: -10)
    
    
    //Dimension scène
    private var sceneX:CGFloat = CGFloat()
    private var sceneY:CGFloat = CGFloat()
    
    //Dimension perso
    private var dimPerso:CGSize = CGSize(width: 102, height: 162)
    
    //Dimension enemy
    private var dimEnemy:CGSize = CGSize(width: 72, height: 70)
    
    
    override func didMove(to view: SKView) {
        self.anchorPoint=CGPoint(x: 0, y: 0)
        sceneX = self.size.width
        sceneY = self.size.height
        physicsWorld.gravity = gravity
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: frame.minX, y: frame.minY, width: frame.width*2, height: frame.height))
        addBackgrounds()
        addPerso()
        perso.run(SKAction.repeatForever(marcher()))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        nbRandom = Int.random(in: 1...80)
        if nbRandom==7 {
            print("creation ennemi\(nbe)")
            nbe+=1
            addEnemy()
        }
        moveBackgrounds()
        moveEnemy()
    }

    
    //[[  Creation personnage
    
    func addPerso(){
        perso = SKSpriteNode(imageNamed: "marche1")
        perso.name="perso"
        
        perso.zPosition=0
        perso.anchorPoint=CGPoint(x: 0, y: 0)
        perso.position=CGPoint(x: 200, y: 50)
        
        perso.size = dimPerso
        
        perso.physicsBody = SKPhysicsBody(rectangleOf: dimPerso)
        perso.physicsBody?.allowsRotation=false
        
        self.addChild(perso)
    }
    
    
    //[[ Animation perso/enemy
    func marcher() -> SKAction {
        var textures:[SKTexture] = []
        for i in 2...5 { textures.append(SKTexture(imageNamed: "marche\(i)")) }
        let animMarche = SKAction.animate(with: textures, timePerFrame: 0.2)
        
        return animMarche
    }
    
    func frapper() -> SKAction {
        var textures:[SKTexture] = []
        for i in 1...4 { textures.append(SKTexture(imageNamed: "frappe\(i)")) }
        hitting = true
        let animFrappe = SKAction.animate(with: textures, timePerFrame: 0.05)
        hitting = false
        
        return animFrappe
    }
    
    func walkEnemy() -> SKAction {
        var textures:[SKTexture] = []
        for i in 1...2 { textures.append(SKTexture(imageNamed: "ennemi\(i)")) }
        let animWalk = SKAction.animate(with: textures, timePerFrame: 0.2)
        
        return animWalk
    }
    
    
    //]]
    
    
    //[[ Creation et gestion mouvement du background
    
    func addBackgrounds(){
        for i in 0...3{
            let bg = SKSpriteNode(imageNamed: "Forest")
            bg.name="bg"
            bg.zPosition = -1
            bg.anchorPoint=CGPoint(x: 0, y: 0)
            bg.position=CGPoint(x: i * Int(bg.size.width), y: 0)
            
            self.addChild(bg)
            
        }
    }
    
    func moveBackgrounds(){
        self.enumerateChildNodes(withName: "bg", using: {(node, stop) -> Void in
            if let bg = node as? SKSpriteNode{
                bg.position = CGPoint(x: bg.position.x - self.bgVelocity, y: bg.position.y)
            
                if bg.position.x <= -bg.size.width{
                    bg.position = CGPoint(x: bg.position.x + bg.size.width*3, y: bg.position.y)
                }
            }
    })
    }
    
    //]]
    
    //[[Creation enemy ( annimation tjr pareil sinon avant de mourir affiche ennemiSonné donc config inAddEnemy
    
    func addEnemy(){
        let enemy = SKSpriteNode(imageNamed: "ennemi1")
        let randomX = CGFloat.random(in: sceneX...(sceneX*2))
        let randomY = CGFloat.random(in: 100...(sceneY))
        
        enemy.name = "ennemi"
        
        enemy.zPosition=0
        enemy.anchorPoint=CGPoint(x: 0, y:0)
        enemy.position=CGPoint (x: randomX, y: randomY)
        
        enemy.size = dimEnemy
        
        //enemy.physicsBody = SKPhysicsBody(rectangleOf: dimEnemy)
        enemy.physicsBody?.affectedByGravity=false
        enemy.run(SKAction.repeatForever(walkEnemy()))
        
        self.addChild(enemy)
    }
    
    func moveEnemy(){
        self.enumerateChildNodes(withName: "ennemi", using: {(node, stop) -> Void in
            if let ennemi = node as? SKSpriteNode{
                ennemi.position = CGPoint(x: ennemi.position.x - self.enemyVelocity, y: ennemi.position.y)
                if ennemi.position.x <= 50 {
                    ennemi.removeFromParent()
                }
                //Si evt contact et hitting meurt
            }
        })
    }
    
    //]]
    
    
    //Gestion des pressions sur écran
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locY = touch.location(in: self).y
            let locX = touch.location(in: self).x
            
            //Gestion saut
            if (locY > (sceneY/2)) && (locX > (sceneX/2)) {
                print("saut")
                perso.physicsBody?.applyImpulse(saut)
            }
            
            //Gestion des frappes
            if (locY <= (sceneY/2)) {
                print("frappe")
                perso.run(frapper())
            }
            
        }
    }
    
    
    
    //]]
    
}
    
    
    

