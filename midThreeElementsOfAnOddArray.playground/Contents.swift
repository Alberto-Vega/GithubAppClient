//: Playground - noun: a place where people can play

import UIKit

func findMiddleThreeElements(array:[Int]) {
    var newArray = [Int]()
    let middleItemIndex = (array.count - 1) / 2
    newArray.append(array[middleItemIndex - 1])
    newArray.append(array[middleItemIndex])
    newArray.append(array[middleItemIndex + 1])
    
print(newArray)
}

var oddArrayOfInts = [1,2,3,4,5,6,7]
var secondArray = [1,2,3,4,5,6,7,8,9,10,11]
//findMiddleThreeElements(oddArrayOfInts)
findMiddleThreeElements(secondArray)

