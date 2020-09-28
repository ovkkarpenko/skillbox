import Foundation

public protocol Movable {
    func move(to position: CGPoint)
}

public class Bird: Movable {
    public init() {
        
    }
    
    public func move(to position: CGPoint) {
        print("Bird is moving to \(position)")
    }
}

public class Dog: Movable {
    public init() {
        
    }
    
    public func move(to position: CGPoint) {
        print("Dog is moving to \(position)")
    }
}

public class Animals {
    private var animals: [Movable] = []
    
    public init() {
        
    }
    
    public func add(_ animal: Movable) {
        animals.append(animal)
    }
    
    public func move(to position: CGPoint) {
        for animal in animals {
            animal.move(to: position)
        }
    }
}
