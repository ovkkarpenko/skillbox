import UIKit
import Foundation

//Task 4
//Дженерики нужны для написания более универсального кода

//Task 5
//ассоциированные типы могут быть определены в протоколе и в них можно использовать операторы ограничений например where
//дженерики могут быть определены только в классе или структуре и в них нельзя использовать ограничения, только через extension

//Task 6
//a
func isEqual<T: Equatable>(_ lhs: T, _ rhs: T) {
    if lhs == rhs {
        print("Elements are the same")
    } else {
        print("Elements are different")
    }
}

////b
func printBiggerElement<T: Comparable>(_ lhs: T, _ rhs: T) {
    print(lhs > rhs ? lhs : rhs)
}

////c
func swapElements<T: Comparable>(_ lhs: inout T, _ rhs: inout T) {
    if lhs > rhs {
        (lhs, rhs) = (rhs, lhs)
    }
}

//d
typealias VoidFunc<T> = (_ param: T) -> Void

func myFunc<T>(_ func1: @escaping VoidFunc<T>, _ func2: @escaping VoidFunc<T>) -> VoidFunc<T> {
    return { param in
        func1(param)
        func2(param)
    }
}

func func1<T>(_ param: T) {
    print(param)
}

func func2<T>(_ param: T) {
    print(param)
}

//Task 7
//a
extension Array where Element: Comparable {
    var maxElement: Element {
        var max: Element = self[0]
        
        self.forEach { item in
            if item > max {
                max = item
            }
        }
        
        return max
    }
}

//b
extension Array where Element: Equatable {
    func distinct() -> Array {
        var newArray: Array = []
        
        self.forEach { item in
            if newArray.firstIndex(of: item) == nil {
                newArray.append(item)
            }
        }
        
        return newArray
    }
}

//Task 8

//a
infix operator ^^: AdditionPrecedence
extension Int {
    static func ^^(left: Int, right: Int) -> Int {
        return Int(pow(Double(left), Double(right)))
    }
}

//b
infix operator ~>: AdditionPrecedence
extension Int {
    static func ~>(left: Int, right: inout Int) {
        right = left*2
    }
}

//c
protocol MyDelegate {
    func setField(_ param: Int)
}

class MyController: UIViewController, UITableViewDelegate {
    
}

class MyTable: UITableView {
    
}

infix operator <*: AdditionPrecedence
extension MyController {
    static func <*(myController: inout MyController, tableView: inout MyTable) {
        tableView.delegate = myController.self
    }
}

//d
struct MyCustromNumber: CustomStringConvertible {
    
    var number: Int
    
    var description: String {
        return "\(number)"
    }
    
}

struct MyCustromString: CustomStringConvertible {
    
    var string: String
    
    var description: String {
        return string
    }
    
}

infix operator +: AdditionPrecedence
extension MyCustromNumber {
    static func +(_ left: MyCustromNumber, _ right: MyCustromString) -> String {
        return "\(left) \(right)"
    }
}

//Task 9
//a

