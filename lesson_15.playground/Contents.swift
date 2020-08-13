import UIKit
import Dispatch

//Task 1
//Это функция что не использует внешних переменных и работает только с теми параметрамми что передали или переменными что были созданны в самой функции

var nums = [2, 3, 5, 8, 11, 20, 18, -1]

//Task 2
nums.sorted()

//Task 3
var numsToStr = nums.map { num in return "\(num)" }
numsToStr

//Task 4
var people = ["Alex", "Max", "Oleg", "Pasha"]
let strPeople = people.reduce("") { "\($0) \($1)" }
strPeople

//Task 5
typealias MyFunc = () -> Void

print("Program is started")

func executeWithDelay(myFunc: @escaping MyFunc) {
    print("Function is executed")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: myFunc)
}

executeWithDelay {
    print("Program is ended\n\n")
}

//Task 6
func executeTwoFunctions(myFunc1: @escaping MyFunc, myFunc2: @escaping MyFunc) -> MyFunc {
    return {
        myFunc1()
        myFunc2()
    }
}

let response =
    executeTwoFunctions(
        myFunc1: {
            print("first function")
    },
        myFunc2: {
            print("second function")
    })

response()

//Task 7
typealias SortNums = (_ a: Int, _ b: Int) -> Bool

func mySort(nums: [Int], sort: SortNums) -> [Int] {
    var sortedNums = nums
    
    while true {
        var flag = false
        
        for i in 0..<sortedNums.count-1 {
            if sort(sortedNums[i], sortedNums[i+1]) {
                (sortedNums[i], sortedNums[i+1]) = (sortedNums[i+1], sortedNums[i])
                flag = true
            }
        }
        
        if !(flag) {
            break
        }
    }
    
    return sortedNums
}

let sortedNums = mySort(nums: nums, sort: { (a: Int, b: Int) in return a > b })
nums
sortedNums

//Task 8
//infix объявляет двоичный оператор, который действует на два значения между ними, например 2+3
//модификаторы prefix и postfix объявляют, должен ли оператор быть до или после, соответственно, значением, на котором он действует.

/*
 ---New Tasks---
 */

//Task 1
//Я вообще не понял смысл задания, что от меня требуеться сделать
func func1(param: (_ a: Int) -> Int) -> Int {
    return param(1)
}

func func2(a: Int) -> Int {
    return a + a
}

func1(param: func2)

func1(param: {(a: Int) -> Int in
    return a + a
})

func1 { a in
    return a + a
}

//Task 3
typealias FuncVoid = () -> Void

var array = [0]
var action: FuncVoid?

func changeGlobalValue(param: @escaping FuncVoid) -> FuncVoid {
    return { param() }
}

class MyClass {
    func func1() {
        action = changeGlobalValue {
            array.append(array.count)
        }
    }
}

let myClass = MyClass()
myClass.func1()
action!()

//Отличие в том что если мы используем escaping то есть возможность сохранить функцию и вызвать ее в будущем когда появиться такая надобность.

var array2 = [0]

let func5 = { array2.append(12) }
func5()

//Task 6
struct MyStruct {
    var a: Int
    var b: Int
}

infix operator ++: RangeFormationPrecedence

extension MyStruct: Equatable {
    static func +(left: MyStruct, right: MyStruct) -> MyStruct {
        print("1")
        return MyStruct(a: left.a * right.a, b: left.b * right.b)
    }
    
    static func ++(left: MyStruct, right: MyStruct) -> MyStruct {
        print("2")
        return MyStruct(a: left.a + right.a, b: left.b + right.b)
    }
    
    static func ==(left: MyStruct, right: MyStruct) -> Bool {
        return (left.a == right.a) && (left.b == right.b)
    }
}

var struck1 = MyStruct(a: 2, b: 2)
var struck2 = MyStruct(a: 2, b: 2)
var struck3 = MyStruct(a: 2, b: 2)
struck1 == struck2

var struck4 = struck1 ++ struck2 + struck3
struck4.a
struck4.b

//Task 9
func apply(_ firstValue: Int, for function: @escaping (Int, Int) -> Int) -> ((Int) -> Int) {
    return {(a: Int) in a
        return function(firstValue, a)
    }
}

let sumFunction: (Int, Int) -> Int = { a, b in
    return a + b
}
let tenPlusFunction = apply(10, for: sumFunction)
let tenSumFiveValue = tenPlusFunction(5)
print(tenSumFiveValue) // напечатается 15
let multipleFunction: (Int, Int) -> Int = { a, b in
    return a * b
}
let twoMultipleFunction = apply(2, for: multipleFunction)
let twoMultipleTwelve = twoMultipleFunction(12)
print(twoMultipleTwelve) // напечатается 24
