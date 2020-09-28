import Foundation

protocol Sqrt {
    func sqrt(a: Double) -> Double
}

public class Math {
    public init() {
        
    }
    
    public func sqrt(a: Double) -> Double {
        return Foundation.sqrt(a)
    }
}

public class MathAdapter: Sqrt {
    let math: Math
    
    public init(math: Math) {
        self.math = math
    }
    
    public func sqrt(a: Double) -> Double {
        return math.sqrt(a: a)
    }
}
