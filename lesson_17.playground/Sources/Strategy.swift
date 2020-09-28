import Foundation

public protocol SortStrategy {
    func sort(in array: [Int]) -> [Int]
}

public class SortByAbcStrategy: SortStrategy {
    public init() {
        
    }
    
    public func sort(in array: [Int]) -> [Int] {
        return array.sorted {
            return $0 < $1
        }
    }
}

public class SortByDescStrategy: SortStrategy {
    public init() {
        
    }
    
    public func sort(in array: [Int]) -> [Int] {
        return array.sorted {
            return $0 > $1
        }
    }
}

public class SortPerformer {
    let strategy: SortStrategy
    
    public init(strategy: SortStrategy) {
        self.strategy = strategy
    }
    
    public func sort(in array: [Int]) -> [Int] {
        return strategy.sort(in: array)
    }
}
