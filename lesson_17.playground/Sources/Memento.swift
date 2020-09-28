import Foundation

public class Memento {
    public let state: String
    
    public init(state: String) {
        self.state = state
    }
}

public class Caretaker {
    public var memento: Memento?
    
    public init() {
        
    }
}

public class Originator {
    public var state: String?
    
    public init() {
        
    }
    
    public func setMemento(memento: Memento) {
        state = memento.state
    }
    
    public func restoreMemento() -> Memento? {
        return Memento(state: state ?? "")
    }
}
