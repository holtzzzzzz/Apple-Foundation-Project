import Foundation
import SpriteKit
import SwiftUI



class Obstaculo: SKSpriteNode {
    
    /// Precisamos do cenário para pegar alguns parâmetros
    let cenario: Cenario
    
    /// Deixamos parametrizado a velocidade de movimento
    var panSpeed: TimeInterval { cenario.panSpeed }
    
    /// Precisamos saber antecipadamente qual o tamanho e posição da tela para colocar o personagem no lugar certo
    var screenFrame:CGRect { cenario.screenFrame }
    
    /// Lista de imagens de obstáculos a partir das imagens
    /// Não vamos usar nesse exemplo, pos precisamos do nome de algumas imagens
    let images:[UIImage] = [#imageLiteral(resourceName: "obst_aviao"), #imageLiteral(resourceName: "obst_borracha2"), #imageLiteral(resourceName: "obst_borracha1"), #imageLiteral(resourceName: "obst_lapis"), #imageLiteral(resourceName: "obst_pin"),]
    
    /// Lista dos nomes imagens de obstáculos a partir das imagens
    let imageNames: [String] = ["obst_aviao", "obst_borracha2", "obst_borracha1", "obst_lapis", "obst_pin"]
    
    var aviao:String { imageNames[0] }

    /// Construindo o Obstáculo
    init(cenario: Cenario) {
        self.cenario = cenario

        guard let choosedName = imageNames.randomElement() else {
            fatalError("Não foi possível carregar uma imagem de obstáculo")
        }

        let texture = SKTexture(imageNamed: choosedName)
        
        // Define um tamanho fixo para todos os obstáculos
        let obstacleSize = CGSize(width: 100, height: 100)

        // Cria o SKSpriteNode com tamanho fixo
        super.init(texture: texture, color: .clear, size: obstacleSize)

        isUserInteractionEnabled = false
        self.name = choosedName

        self.physicsBody = criaPhysicsBody(size: obstacleSize)

        // Ajusta a escala manualmente se necessário (opcional)
        // self.setScale(0.5) ← REMOVA isso se você já definiu o tamanho fixo

        posiciona()
    }

    
    func posiciona() {
        /// descobre qual o tamanho da tela
        
        /// Posiciona o nó alinhando seu início com o fim da tela
        self.position.x = CGFloat.random(in: screenFrame.minX..<screenFrame.maxX)
        
        /*
         screenFrame.maxX ==> Ponto inicial à direita da tela
         frame.width ==> O próprio tamanho, para alinhar-se após o fim da tela
         */
        /// Inicia no alto, para o efeito de "cair" no início.
        self.position.y = screenFrame.maxY + frame.height
    }
    
    func criaPhysicsBody(size: CGSize) -> SKPhysicsBody {
        /// Cria um physicsBody retângulo com o tamanho fornecido
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        
        /// Faz esse corpo estático (não é afetado por física, colisões, etc.)
        physicsBody.isDynamic = true
        
        /// Esse corpo é afetado pela gravidade
        /// Apenas se não for um avião
        if name == aviao {
            physicsBody.affectedByGravity = false
        } else {
            physicsBody.affectedByGravity = true
        }
        
        /// Ajusta a massa dos obstáculos para que eles empurrem mais o personagem
        physicsBody.mass = 50
        
        
        /// A categoria para mapeamento de contatos é 2
        physicsBody.categoryBitMask = 2
        
        /// Ele entra em contato (trigger) com objetos de categoryBitMask = 1
        physicsBody.contactTestBitMask = 1 + 16

        /// Ele colide (física) com objetos de categoryBitMask = 2 ou 16
        physicsBody.collisionBitMask = 1 + 16

        return physicsBody
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



#Preview {
    ContentView(sceneClass: GameScene.self)
}

