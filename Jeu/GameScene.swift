//
//  GameScene.swift
//  Jeu
//
//  Created by virassamy brice on 28/03/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

//Peut etre devoir arreter lanimation repeat avant de lancer anim saut et ensuite relance anim repeat

import SpriteKit
import GameplayKit

let persoHitName = "persoHit"
let persoSufferName = "persoSuffer"
let persoJumpName = "persoJump"

var backgroundMusic: SKAudioNode!

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Constantes pour les catégories (collisions/contacts)
    let persoCategory:UInt32 = 1         // 00000000 00000000 00000000 00000001
    let enemyCategory:UInt32 = 2         // 00000000 00000000 00000000 00000010
    let sceneCategory:UInt32 = 4         // 00000000 00000000 00000000 00000100
    
    //Constantes pour les sons
    let persoHit = SKAction.playSoundFileNamed(persoHitName, waitForCompletion: false)
    let persoSuffer = SKAction.playSoundFileNamed(persoSufferName, waitForCompletion: false)
    let persoJump = SKAction.playSoundFileNamed(persoJumpName, waitForCompletion: false)
    
    //Var pour generation aléatoire enemy
    private var nbRandom:Int = 0
    
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
        
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "mp3"){
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        self.anchorPoint=CGPoint(x: 0, y: 0)
        sceneX = self.size.width
        sceneY = self.size.height
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = gravity
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: frame.minX, y: frame.minY, width: frame.width*2, height: frame.height))
        self.physicsBody?.collisionBitMask = sceneCategory
        addBackgrounds()
        addPerso()
        perso.run(SKAction.repeatForever(marcher()))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        addRandomEnemy()
        moveBackgrounds()
        moveEnemy()
    }

    
    //[[  Creation personnage
    
    func addPerso(){
        perso = SKSpriteNode(imageNamed: "marche1")
        perso.name="perso"
        
        perso.zPosition=0
        perso.anchorPoint=CGPoint(x: 0, y: 0)
        perso.position=CGPoint(x: 50, y: 50)
        
        perso.size = dimPerso
        
        perso.physicsBody = SKPhysicsBody(rectangleOf: dimPerso)
        perso.physicsBody?.collisionBitMask = persoCategory
        perso.physicsBody?.contactTestBitMask = enemyCategory
        perso.physicsBody?.allowsRotation=false
        self.addChild(perso)
    }
    
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
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: dimEnemy)
        enemy.physicsBody?.collisionBitMask = enemyCategory
        enemy.physicsBody?.affectedByGravity=false
        enemy.run(SKAction.repeatForever(walkEnemy()))
        
        self.addChild(enemy)
    }
    
    func addRandomEnemy() {
        nbRandom = Int.random(in: 1...80)
        if nbRandom==7 {
            addEnemy()
        }
    }
    
    func moveEnemy(){
        self.enumerateChildNodes(withName: "ennemi", using: {(node, stop) -> Void in
            if let ennemi = node as? SKSpriteNode{
                ennemi.position = CGPoint(x: ennemi.position.x - self.enemyVelocity, y: ennemi.position.y)
                if ennemi.position.x <= 50 {
                    ennemi.removeFromParent()
                }
            }
        })
    }
    
    //]]
    
    //[[ ACTIONS LORS DES CONTACTS
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name=="perso" && contact.bodyB.node?.name=="ennemi"){
            if(!(hitting)) {
                life-=1 ; print(life) ;
                play(sound: persoSuffer)
                
            }
            if(hitting) {score+=1 ; print(score) }
            contact.bodyB.node?.removeFromParent()
        }
        if(contact.bodyB.node?.name=="perso" && contact.bodyA.node?.name=="ennemi"){
            contact.bodyA.node?.removeFromParent()
        }
    }
    
    //]]
    
    //[[ Fonction play pour jouer un son
    
    func play(sound : SKAction){
        run(sound)
        print("son")
    }
    
    //]]
    
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
        play(sound: persoHit)
        let animFrappe = SKAction.animate(with: textures, timePerFrame: 0.05)
        
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
    
    //Gestion des pressions sur écran
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locY = touch.location(in: self).y
            let locX = touch.location(in: self).x
            
            //Gestion saut
            if (locY > (sceneY/2)) && (locX > (sceneX/2)) {
                play(sound: persoJump)
                perso.physicsBody?.applyImpulse(saut)
            }
            
            //Gestion des frappes
            if (locY <= (sceneY/2)) {
                hitting = true
                perso.run(frapper())
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (hitting) {hitting=false}
    }
    
    
    
    //]]
    
}
    
    
    

