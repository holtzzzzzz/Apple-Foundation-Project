

import SpriteKit
import GameplayKit
import SwiftUI

class GameScene4Test: SKScene {
    
    var cenario:Cenario!
    

    override func didMove(to view: SKView) {
        
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        print(view.frame.size)
        
        // Colocar o cenário na tela
        cenario = Cenario(screenFrame: self.frame)
        addChild(cenario)

        
    }
    
    

    var touchedNode: SKNode?
    var initialTouchedPosition: CGPoint?
    var initialNodePosition: CGPoint?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let node = nodes(at: location).first else { return }
        
        touchedNode = node
        initialTouchedPosition = location
        initialNodePosition = node.position
    }
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let initialNodePosition = initialNodePosition,
              let initialTouchedPosition = initialTouchedPosition,
              let touchedNode = touchedNode else { return }
        
        touchedNode.position = initialNodePosition +
                            (location - initialTouchedPosition)
        
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}







#Preview {
    ContentView(sceneClass: GameScene4Test.self)
}
