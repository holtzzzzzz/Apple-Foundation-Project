import Foundation
import SpriteKit
import SwiftUI

// Cenário

class Cenario: SKSpriteNode {
    /// Deixamos parametrizado a velocidade de movimento
    static let panSpeed: TimeInterval = 6.0
    let panSpeed: TimeInterval = Cenario.panSpeed

    // Com 2 frames de cenário em uma imagem + uma duplicata do 1º frame, com emenda perfeita, movimentaremos o cenário e o retornaremos para a posição inicial
    var qntdMovimento:CGFloat { self.frame.size.width / 3 * 2 }
    
    /// Precisamos saber antecipadamente qual o tamanho e posição da tela para colocar o cenário no lugar certo
    let screenFrame:CGRect
    
    /// Construindo o Cenário
    init(screenFrame:CGRect) {
        /// Inicia as variaveis locais com parâmetro(s) passado(s)

        /// Tamanho da tela a qual o cenário será inserido
        self.screenFrame = screenFrame
        
        /// Cria uma textura com o fundo de papel
        let texture = SKTexture(imageNamed: "papel")
        
        /// captura o tamanho dessa textura
        let size = texture.size()
        
        /// calcula a proporção entre a tela e a textura
        let scale = screenFrame.height / size.height
        
        /// Constrói o nó (fundo), com a textura e do tamanho da textura e partir de um construtor padrão de meu pai (SKSpriteNode)
        super.init(texture: texture, color: .clear, size: size)

        /// Configura propriedades do nó
            /// Não se interage com o fundo
        isUserInteractionEnabled = false

            /// Adiciona o chão
        adicionaChao()
        
            /// Ajusta a escala do nó para ter a mesma altura da tela
            /// OBS: A ordem importa ao mudar a escala. Se adicionamos todos os filhos e escalamos depois. Caso contrário você poderá ter dificuldade para adicionar objetos.
        setScale(scale)
        
        /// posiciona o cenário
        posiciona()

        
        /// Inicia movimento do cenário
    }
    
    func adicionaChao() {
        /// Cria o nó do chão
        let node = SKSpriteNode(imageNamed: "chao")
        node.size.width = self.frame.width
        /// Posiciona no fundo do cenário
        node.position.y = self.frame.minY + (node.frame.size.height/2)-92.5

        /// Adiciona no papel
        self.addChild(node)

        /// Cria o tamanho do corpo físico
        var bodySize = node.frame.size
        /// Ajusta esse tamanho, se for o caso. Para nosso chão vamos querer que os elementos fiquem entre as duas linhas superiores
        bodySize.height *= 0.50

        // Adicionar um corpo físico ao chão do cenário
        let physicsBody = criaPhysicsBody(size: bodySize)
        node.physicsBody = physicsBody
        
    }
    
    func criaPhysicsBody(size: CGSize) -> SKPhysicsBody {
        /// Cria um physicsBody retângulo com o tamanho fornecido
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        
        /// Faz esse corpo estático (não é afetado por física, colisões, etc.)
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        
        /// A categoria para mapeamento de contatos e colisões
        physicsBody.categoryBitMask = 16
        physicsBody.contactTestBitMask = 0 // 0 = não mapeia
        physicsBody.collisionBitMask = 1 + 2
        /**
         O que significam esses números?
            As categorias, precisam ser potências de 2 (1, 2, 4, 8, 16, ...)
            - 0 == Não mapeia
         - categoryBitMask = 16      ==> Minha própria categoria
         - contactTestBitMask = 0    ==> Faço contato com elementos dessa categoria
         - collisionBitMask = 1         ==> colido, via física, com elementos dessa categoria
         
            - Contato é um trigger. Aciona a função did
         */
        return physicsBody
    }
  
    
    func posiciona() {
        /// Posiciona o nó alinhando seu início com o início da tela
        self.position.x = screenFrame.minX - self.frame.minX

    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



#Preview {
    ContentView(sceneClass: GameScene.self)
}

