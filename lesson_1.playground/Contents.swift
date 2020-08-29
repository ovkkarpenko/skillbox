import UIKit

//Task 4
//В протоколе нельзя создать реализацию метода или свойства, только если создать extension для протокола и сделать реализацию в нем

//Task 5
//Tuples вообще не могут реализовывать протоколы

//Task 6
//a
struct ChessPiecePosition {
    var x: Int
    var y: Int
}

protocol ChessMovedDelegate {
    func moved(from fromPosition: ChessPiecePosition, to toPosition: ChessPiecePosition)
}

protocol ChessMovable {
    func move(from fromPosition: ChessPiecePosition, to toPosition: ChessPiecePosition)
}

var calculateCurrentPosition: Double {
    get {
        return 0.0
    }
}

//b
protocol Flyable {
    func fly()
}

protocol Drawable {
    func draw()
}

class Circle: Drawable {
    func draw() {
        
    }
}

class Bird: Flyable {
    func fly() {
        
    }
}

//Task 7
extension CGRect {
    //a
    func center() -> CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    //b
    func area() -> Int {
        return Int(self.width * self.height)
    }
}

//c
extension UIView {
    func hideView() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        }
    }
}


//d
struct Number {
    var a: Int
}

extension Number: Comparable {
    static func < (lhs: Number, rhs: Number) -> Bool {
        return true
    }
    
    func bound(minValue: Number, maxValue: Number) -> Number {
        if self.a < minValue.a {
            return minValue
        } else if self.a > maxValue.a {
            return maxValue
        }
        return self
    }
}

//e
extension Array where Element == Int {
    func sum() -> Int {
        return self.reduce(0) { $0 + $1}
    }
}

//Task 8
//Использование POP повышает переиспользование кода, лучше структурирует код, уменьшает дублирование кода, избегает сложности с иерархией наследования классов, делает код более связным.
