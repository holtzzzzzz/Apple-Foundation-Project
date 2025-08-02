import Foundation
import SpriteKit
import SwiftUI

class Personagem: SKSpriteNode {
    
    let animationSpeed:TimeInterval = 0.15
    var posicaoInicial:CGPoint?
    
    /// Precisamos saber antecipadamente qual o tamanho e posição da tela para colocar o personagem no lugar certo
    let screenFrame:CGRect
    
    /// Construindo o Personagem
    init(screenFrame:CGRect) {
        
        /// Inicia as variaveis locais com parâmetro(s) passado(s)
        self.screenFrame = screenFrame

        ///  Cria uma lista de texturas do personagem, que será usada na animação
        let textures = [SKTexture(imageNamed: "personagem01"),
                        SKTexture(imageNamed: "personagem02"),
                        SKTexture(imageNamed: "personagem03"),
                        SKTexture(imageNamed: "personagem04"),]
        
        /// Cria uma textura com o personagem
        let texture = textures[0] // podemos pegar qualqer textura da lista para as animações
        
        /// captura o tamanho dessa textura
        let size = texture.size()

        /// calcula a proporção da textura
        let scale = 0.40
        
        /// Constrói o nó, com a textura e do tamanho da textura e partir de um construtor padrão de meu pai (SKSpriteNode)
        super.init(texture: texture, color: .clear, size: size)

        /// Configura propriedades do nó
            /// Iremos interagir diretamente com o personagem
        isUserInteractionEnabled = true
        
        self.name = "personagem"

        /// Adiciona o corpo físico do personagem
        self.physicsBody = criaPhysicsBody(size: size)

        setScale(scale)

        posiciona()
        
        iniciaAnimacao(com: textures)

    }

    var moveCounter: Int = 0
    var movingRight: Bool = false
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        guard let parentScene = scene else { return }
        let location = touch.location(in: parentScene)
        

        let isMovingRight: Bool = (location.x > self.position.x)
        if  movingRight {
            if counntBuffer(moving: isMovingRight) {
                self.xScale = -abs(self.xScale)
            }
        } else {
            if counntBuffer(moving: isMovingRight) {
                self.xScale = abs(self.xScale)
            }
        }
        self.position = CGPoint(x: location.x, y: self.position.y)
        if self.contains(location) {
            self.position = CGPoint(x: location.x, y: self.position.y)
        }
        movingRight = isMovingRight

    }
    
    
    func counntBuffer(moving: Bool)->Bool {
        if moving == movingRight {
            moveCounter += 1
        } else {
            moveCounter = 0
        }
        
        return moveCounter >= 4
    }
    
    func posiciona() {
        /// descobre qual o tamanho da tela
        
        /// Posiciona o nó alinhando seu início com o início da tela, deixando uma margem
        self.position.x = frame.width/2 - 40
        
        /// Inicia no alto, para o efeito de "cair" no início.
        self.position.y = screenFrame.maxY + frame.height
    }
    
    func criaPhysicsBody(size: CGSize) -> SKPhysicsBody {
        /// Cria um physicsBody retângulo com o tamanho fornecido
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        
        /// Faz esse corpo dinâmico (é afetado por física, colisões, etc.)
        physicsBody.isDynamic = true
        
        /// Esse corpo é afetado pela gravidade
        physicsBody.affectedByGravity = true
        
        /// Esse corpo não rotaciona
        physicsBody.allowsRotation = false
        
        /// A categoria para mapeamento de contatos é 1
        physicsBody.categoryBitMask = Categoria.personagem
        
        /// Ele entra em contato (trigger) com objetos de categoryBitMask = 2
        physicsBody.contactTestBitMask = Categoria.obstaculo

        /// Ele colide (física) com objetos de categoryBitMask = 2 ou 16
        physicsBody.collisionBitMask = Categoria.obstaculo + Categoria.chao

        return physicsBody
    }
    
    func iniciaAnimacao(com textures: [SKTexture]) {
        run(SKAction.repeatForever(
            SKAction.animate(with: textures,
                             timePerFrame: animationSpeed)
        ))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

#Preview {
    ContentView(sceneClass: GameScene.self)
}

