//: Playground - noun: a place where people can play

import UIKit

func withinTwoOfMultipleOfTen(num: Int) -> Bool {
    
    if (num) % 10 == 2 || (num % 10) == 8 {
        return true
    } else {
        return false
    }
}

var num = 32
var secondNum = 18
var thirdNum = 11
withinTwoOfMultipleOfTen(num)
withinTwoOfMultipleOfTen(secondNum)
withinTwoOfMultipleOfTen(thirdNum)

