
import SpriteKit


extension SKNode {
    var isInsideScene: Bool {
        guard let scene = self.scene else { return false }
        return self.frame.maxX < scene.frame.minX ||
               self.frame.maxY < scene.frame.minY ||
               self.frame.minX > scene.frame.maxX ||
               self.frame.minY > scene.frame.maxY
    }
}


extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

extension SKPhysicsContact {
    func getNodeIfNameStart(with name: String?) -> SKNode? {
        guard let name,
              let nodeA = self.bodyA.node,
              let nodeB = self.bodyB.node else {return nil}
        return [nodeA, nodeB].first { $0.name?.starts(with: name) ?? false  }
        
    }
    func getNodeIfName(is name: String?) -> SKNode? {
        guard let name,
              let nodeA = self.bodyA.node,
              let nodeB = self.bodyB.node else {return nil}
        return [nodeA, nodeB].first { $0.name == name }
        
    }
}


extension [SKNode] {
    func removeAllActions() {
        for node in self {
            node.removeAllActions()
        }
    }
}
