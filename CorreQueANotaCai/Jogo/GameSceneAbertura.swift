import SpriteKit
import GameplayKit
import SwiftUI

class GameSceneAbertura: SKScene {
    
    var cenario: Cenario!
    var dificuldadeSelecionada: String = "fácil" 
    var dificuldadeLabels: [SKLabelNode] = []

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        cenario = Cenario(screenFrame: self.frame)
        addChild(cenario)
        
        addDifficultyBox()
    }
    
    func addDifficultyBox() {
        let box = SKShapeNode(rectOf: CGSize(width: 300, height: 250), cornerRadius: 15)
        box.fillColor = .white
        box.strokeColor = .gray
        box.position = CGPoint(x: 0, y: 0)
        box.name = "difficultyBox"
        addChild(box)
        
        let titleLabel = SKLabelNode(text: "Escolha a dificuldade")
        titleLabel.fontSize = 22
        titleLabel.fontName = "HelveticaNeue-Bold"
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: 0, y: 80)
        box.addChild(titleLabel)

        let difficulties = ["Fácil", "Médio", "Difícil"]
        dificuldadeLabels.removeAll()

        for (index, diff) in difficulties.enumerated() {
            let label = SKLabelNode(text: diff)
            label.fontSize = 20
            label.fontName = "HelveticaNeue"
            label.fontColor = (diff.lowercased() == dificuldadeSelecionada) ? .blue : .darkGray
            label.position = CGPoint(x: 0, y: 30 - CGFloat(index) * 40)
            label.name = "difficulty_\(diff.lowercased())"
            box.addChild(label)
            dificuldadeLabels.append(label)
        }

        let startButton = SKLabelNode(text: "Iniciar Jogo")
        startButton.fontSize = 20
        startButton.fontName = "HelveticaNeue-Bold"
        startButton.fontColor = .black
        startButton.position = CGPoint(x: 0, y: -90)
        startButton.name = "startButton"
        box.addChild(startButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if let name = node.name {
            if name == "startButton" {
                iniciarJogo()
            } else if name.starts(with: "difficulty_") {
                atualizarDificuldadeSelecionada(nome: name)
            }
        }
    }

    func atualizarDificuldadeSelecionada(nome: String) {
        if let dificuldade = nome.components(separatedBy: "_").last {
            dificuldadeSelecionada = dificuldade

            for label in dificuldadeLabels {
                if label.name == "difficulty_\(dificuldadeSelecionada)" {
                    label.fontColor = .blue
                } else {
                    label.fontColor = .darkGray
                }
            }
        }
    }

    func iniciarJogo() {
        childNode(withName: "difficultyBox")?.removeFromParent()

        guard let view else { return }
        let nextScene = GameScene(size: self.size)
        nextScene.scaleMode = .aspectFill

        if let gameScene = nextScene as? GameScene {
            gameScene.dificuldade = dificuldadeSelecionada
            print(gameScene.dificuldade)
        }

        view.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
    }
}




#Preview {
    ContentView(sceneClass: GameSceneAbertura.self)
}
