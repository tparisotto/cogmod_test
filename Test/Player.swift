//
//  Player.swift
//  Liar's Dice
//
//  Created by Tommaso Parisotto on 14/02/2020.
//  Copyright © 2020 CogMod. All rights reserved.
//

import Foundation

class Player
{
    var numberOfDiceInHand: Int
    var hand: [Dice] = []
    
    init()
    {
        self.numberOfDiceInHand = 6
        for _ in 0..<numberOfDiceInHand { self.hand.append(Dice()) }
    }
    
    func loseDice()
    {
        if numberOfDiceInHand < 1
        {
            print("Error: attempting to remove dice with 0 dice in hand.")
        }
        else
        {
            self.hand.removeLast()
            self.numberOfDiceInHand -= 1
        }
    }
    
    func addDice()
    {
        self.hand.append(Dice())
        self.numberOfDiceInHand += 1
    }
    
    
    func rollHand()
    {
        for index in 0..<numberOfDiceInHand { _ = self.hand[index].roll() }
    }
    
    
    func getRollNumber(roll: Int) -> Int
    {
        var sum = 0
        for die in hand
        {
            if die.faceValue == roll {sum += 1}
        }
        return sum
    }
    
    func getHand() -> [Int]
    {
        var playerhand : [Int] = []
        for die in hand
        {
            playerhand.append(die.faceValue)
        }
        return playerhand
    }
}
