import Foundation


func checkArr(_ arr: [Int]) -> String {
    for index in 1..<arr.count - 1 {
        var leftSum = 0
        var rightSum = 0
        
        //
        let lastIndexLeftSide = index - 1
        for i in 0...lastIndexLeftSide {
            leftSum += arr[i]
        }
        
        //
        let lastIndexRightSide = arr.count - 1
        let currentIndexRightSide = index + 1
        
        for i in currentIndexRightSide...lastIndexRightSide {
            rightSum += arr[i]
        }
        
        //
        if leftSum == rightSum {
            return ("result at index \(index), sum is \(rightSum)")
        }
    }
    
    return ("not found")
}

print(checkArr([3, 6, 8, 1, 5, 10, 1, 7]))

func checkPalindrome(_ word: String) -> String {
    let wordArray = Array(word.lowercased())
    for index in 0..<wordArray.count/2 {
        let lastIndex = wordArray.count - 1
        let symmetryIndex = wordArray[lastIndex - index]
        if wordArray[index] != symmetryIndex {
            return "\(word) is not a palindrome"
        }
    }
    return "\(word) is a palindrome"
}

print(checkPalindrome("Level"))
