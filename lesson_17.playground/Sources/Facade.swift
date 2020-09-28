import Foundation

class Engine {
    func produceEngine() {
        print("prodce engine")
    }
}

class Body {
    func produceBody() {
        print("prodce body")
    }
}

class Accessories {
    func produceAccessories() {
        print("prodce accessories")
    }
}

public class FactoryFacade {
    let engine = Engine()
    let body = Body()
    let accessories = Accessories()
    
    public init() {
        
    }
    
    public func produceCar() {
        engine.produceEngine()
        body.produceBody()
        accessories.produceAccessories()
    }
}
