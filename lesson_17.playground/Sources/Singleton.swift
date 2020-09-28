public struct LogManager {
    public static let shared = LogManager()
    
    var logs: [String] = []
    
    private init() {
        
    }
    
    public mutating func log(_ s: String) {
        logs.append(s)
    }
    
    public func getLogs() -> String {
        return logs.joined(separator: "\n")
    }
}
