
import SwiftUI
import SpriteKit

struct ContentView: View {
    var sceneClass: SKScene.Type = GameScene.self
    
    var body: some View {
        GeometryReader{ geometry in
            SpriteView(scene: sceneClass.init(size: geometry.size))
                .ignoresSafeArea(edges: .all)
            

            
        }
    }
}

#Preview {
    ContentView()
}
