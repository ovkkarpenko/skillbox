import Foundation

public struct Object {
    var position: CGPoint?
}

protocol ObjectBuilder {
    func setPosition(_ position: CGPoint)
}

class PlayerBuilder: ObjectBuilder {
    var player: Object
    
    init(player: Object) {
        self.player = player
    }
    
    func setPosition(_ position: CGPoint) {
        player.position = position
    }
}

public class Game {
    public init() {
        
    }
    
    public func createPlayer() -> Object {
        let player = Object()
        let builder = PlayerBuilder(player: player)
        builder.setPosition(CGPoint(x: 0, y: 0))
        return builder.player
    }
}
