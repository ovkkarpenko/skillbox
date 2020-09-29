//
//  MyArray.swift
//  lesson_18
//
//  Created by Oleksandr Karpenko on 28.09.2020.
//

import Foundation

class MyArray {
    
    let array: [Int]
    
    init(array: [Int]) {
        self.array = array
    }
    
    func min() -> Int? {
        return array.min()
    }
    
    func max() -> Int? {
        return array.max()
    }
    
    func sortByAbc() -> [Int] {
        return array.sorted {
            return $0 < $1
        }
    }
    
    func sortByDesc() -> [Int] {
        return array.sorted {
            return $0 > $1
        }
    }
    
    func join() -> String {
        return array.reduce("") { return $0 == "" ? "\($1)" : "\($0) \($1)"}
    }
    
}
