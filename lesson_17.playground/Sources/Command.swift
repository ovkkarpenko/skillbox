import Foundation

public class Player {
    public init() {
        
    }
}

protocol PlayerCommand {
    func execute(player: Player)
}

class PlayerMoveCommand: PlayerCommand {
    func execute(player: Player) {
        print("move...")
    }
}

class PlayerStopCommand: PlayerCommand {
    func execute(player: Player) {
        print("stop...")
    }
}

public class PlayerOperations {
    let player: Player
    private let moveCommand = PlayerMoveCommand()
    private let stopCommand = PlayerStopCommand()
    
    public init(player: Player) {
        self.player = player
    }
    
    public func move() {
        moveCommand.execute(player: player)
    }
    
    public func stop() {
        stopCommand.execute(player: player)
    }
}
