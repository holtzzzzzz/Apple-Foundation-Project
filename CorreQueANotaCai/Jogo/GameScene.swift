import SpriteKit
import GameplayKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    var dificuldade: String = "fácil"
    var tempoLabel = SKLabelNode()
    var tempoInicial:Double = 60
    var highscore: Double = 0.0
    var tempo: Double = 60.0 {
        didSet {
            tempoLabel.text = "Tempo: \(tempo)"
        }
    }
    var scoreLabel = SKLabelNode()
    var score:Double = 10.0 {
        didSet {
            scoreLabel.text = "Nota: \(score)"
        }
    }
    
    
        
    var jogoRolando:Bool = true
    
    var personagem:Personagem!

    var cenario:Cenario!
    
    func começaAAdicionarObstaculos() {
        guard jogoRolando else { return }
        
        let intervaloAleatorio = TimeInterval.random(in: 0.8...1.7)
        
        Timer.scheduledTimer(withTimeInterval: intervaloAleatorio, repeats: false, block: {_ in
            let obstaculo = Obstaculo(cenario: self.cenario)
            self.addChild(obstaculo)
            self.começaAAdicionarObstaculos()
        })
        

        
    }
    
    func começaAAdicionarObstaculos2() {
        guard jogoRolando else { return }
        
        let intervaloAleatorio = TimeInterval.random(in: 0.8...1.7)
        let intervalo:DispatchTime = .now() + intervaloAleatorio
        
        DispatchQueue.main.asyncAfter(deadline: intervalo) {
            let obstaculo = Obstaculo(cenario: self.cenario)
            self.addChild(obstaculo)
            self.começaAAdicionarObstaculos()
        }
    }

    
  
    
    
    override func didMove(to view: SKView) {
            // Carregar o highscore salvo no UserDefaults
        if let savedHighscore = UserDefaults.standard.value(forKey: "highscore") as? Double {
            highscore = savedHighscore
        }
        
        // O resto do código permanece o mesmo
        switch dificuldade.lowercased() {
        case "fácil":
            tempo = 30
            tempoInicial = 30
        case "médio":
            tempo = 60
            tempoInicial = 60
        case "difícil":
            tempo = 90
            tempoInicial = 90
        default:
            tempo = 60
            tempoInicial = 60
        }
        let gravidade: Double = tempoInicial / 10
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -gravidade)
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        // Colocar o cenário na tela
        cenario = Cenario(screenFrame: self.frame)
        addChild(cenario)
        
        personagem = Personagem(screenFrame: self.frame)
        addChild(personagem)
        
        addScoreLabel()
        addTempoLabel()
        run(SKAction.playSoundFileNamed("Musica.m4a", waitForCompletion: true))
        começaAAdicionarObstaculos()
    

    }
    
    
    func addScoreLabel() {
        score = 10
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scoreLabel.fontName = "HelveticaNeue-Bold"
        scoreLabel.position.x = self.frame.minX + scoreLabel.frame.width
        scoreLabel.position.y = self.frame.maxY - 62
        addChild(scoreLabel)

    }
    
    func addTempoLabel() {
        tempoLabel.fontSize = 30
        tempoLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tempoLabel.fontName = "HelveticaNeue-Bold"
        tempoLabel.position.x = -scoreLabel.position.x
        tempoLabel.position.y = self.frame.maxY - 62
        addChild(tempoLabel)

    }
    func addHighscoreLabel() {
        let highscoreLabel = SKLabelNode(text: "Nota mais alta: \(Double(highscore))")
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = .white
        highscoreLabel.fontName = "HelveticaNeue-Bold"
        highscoreLabel.position = CGPoint(x: 0, y: self.frame.maxY - 100)
        addChild(highscoreLabel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "playButton" {
                let transition = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: size)
                view?.presentScene(gameScene, transition: transition)
            }
        }
        if !jogoRolando {
            gotoNextScene()
        } 
    }

    var frameCounter:Int = 0
    override func update(_ currentTime: TimeInterval) {
        guard jogoRolando else { return }
        
        frameCounter = (frameCounter + 1) % 6
        guard frameCounter == 0 else { return }
        tempo -= 0.1
        tempo = Double(round(10 * tempo)/10)
        if score < 6 {
            gameOver()
            return
        }
        else if tempo <= 0 && score >= 6 {
            venceu()
            return
        }
        
    }
    
    

    func didBegin(_ contact: SKPhysicsContact) {
        let obstaculo = contact.getNodeIfNameStart(with: "obst_") as? Obstaculo

        let personagem = contact.getNodeIfName(is: personagem.name) as? Personagem
       
        if let obstaculo {
            if let personagem {
                obstaculo.removeFromParent()
            }
            else {
                obstaculo.removeFromParent()
                score -= 0.5 + ((tempoInicial/30) - 1)
                score = Double(round(10 * score)/10)
            }
            
        }
        
    }
    
    
    func gameOver() {
        
        addLabelGameOver()
        addLabelToqueNaTela()

        jogoRolando = false
        self.children.removeAllActions()
    }
    func venceu() {
        PassouDeAno()
        addLabelJogarDeNovo()
        jogoRolando = false
        
        if score > highscore {
            highscore = score
            UserDefaults.standard.set(highscore, forKey: "highscore")
        }
        
        addHighscoreLabel()
    }
    func PassouDeAno() {
        let label = SKLabelNode(text: "Você passou de ano!")
        label.fontSize = 50
        label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.fontName = "HelveticaNeue-Bold"
        label.position.y = 22
        addChild(label)
    }
    
    func addLabelJogarDeNovo() {
        let label = SKLabelNode(text: "Toque na tela para jogar de novo!")
        label.fontSize = 30
        label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.fontName = "HelveticaNeue"
        label.position.y -= 12
        addChild(label)
    }
    
    
    func addLabelGameOver() {
        let label = SKLabelNode(text: "Repetiu de ano!")
        label.fontSize = 50
        label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.fontName = "HelveticaNeue-Bold"
        label.position.y = 22
        addChild(label)
    }
    
    func addLabelToqueNaTela() {
        let label = SKLabelNode(text: "Toque na tela para começar")
        label.fontSize = 30
        label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.fontName = "HelveticaNeue"
        label.position.y -= 12
        addChild(label)
    }

    
    func gotoNextScene() {
        guard let view else { return }
        let nextScene = GameScene(size: self.size)
        nextScene.dificuldade = self.dificuldade 
        nextScene.scaleMode = .aspectFill
        view.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))

    }

}




#Preview {
    ContentView()
}
