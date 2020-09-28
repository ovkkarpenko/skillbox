import Foundation

protocol Subject {
    func request()
}

class RealSubject: Subject {
    func request() {
        print("RealSubject")
    }
}

class Proxy: Subject {
    var realSubject: RealSubject!
    
    func request() {
        if realSubject == nil {
            realSubject = RealSubject()
        }
        realSubject.request()
    }
}

public class Client {
    public init() {
        
    }
    
    public func test() {
        let subject: Subject = Proxy()
        subject.request()
    }
}
