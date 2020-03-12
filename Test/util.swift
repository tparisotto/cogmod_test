//
//  util.swift
//  Liar's Dice
//
//  Created by Tommaso Parisotto on 17/02/2020.
//  Copyright © 2020 CogMod. All rights reserved.
//

import Foundation

func computeProbabilityMatrix(hand: [Int], diceInGame: Int) -> [[Double]]
{
    var handCount = [Int](repeating: 0, count: 6)
    for i in hand
    {
        handCount[i-1] += 1
    }
    let zeros = [Double](repeating: 1, count: 6)
    var matrix = [[Double]](repeating: zeros, count: diceInGame+1)
    matrix[0] = [1,1,1,1,1,1] // probability of at least 0 dice is always 1
    for i in 1...diceInGame
    {
        for j in 0..<6
        {
            for k in 1...i
            {
                if k <= handCount[j]
                {
                    matrix[i][j] = 1
                }
                else
                {
                    matrix[i][j] -= (Double(factorial(number: diceInGame)!)/(Double(factorial(number: k - handCount[j])!)*Double(factorial(number: diceInGame-k+handCount[j])!)))*Double(powf(1/3, Float(k-handCount[j])))*Double(powf(2/3, Float(diceInGame-k+handCount[j])))
                }
            }
        }
    }
    return matrix
}

func factorial(number: Int) -> Int? {
    var result = number
    guard result >= 0 else {return nil}
    guard result < 21 else {return nil}
    if number == 0 {return 1}
    for times in 1..<number
    {
        result = result*times
    }
    return result
}

