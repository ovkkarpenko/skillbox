import UIKit

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

func executeWithDelay(myFunc: @escaping MyFunc) {
    print("Function is executed")

    sleep(2)
    myFunc()
}

print("Program is started")
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
//vодификаторы prefix и postfix объявляют, должен ли оператор быть до или после, соответственно, значением, на котором он действует.
