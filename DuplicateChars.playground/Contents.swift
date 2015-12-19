//: Playground - noun: a place where people can play

import UIKit

/* Code Challenge: Given a string, return a string where for every char in the original, there are two chars.
Example: doubleChar("The") → "TThhee" 
*/

var string = "The"
var stringOne = "House"

func duplicateChars(string: String) {
    var newString = String()
    for item in string.characters.enumerate() {
        newString.append(item.element)
        newString.append(item.element)
    }
    print(newString)
}

duplicateChars(string)
duplicateChars(stringOne)
