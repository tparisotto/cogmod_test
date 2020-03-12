//
//  Dice.swift
//  Liar's Dice
//
//  Created by Tommaso Parisotto on 14/02/2020.
//  Copyright © 2020 CogMod. All rights reserved.
//

import Foundation

class Dice
{
    var faceValue: Int
    
    func roll() -> Int
    {
        self.faceValue = Int.random(in: 1...6)
        return self.faceValue
    }
    
    init()
    {
        self.faceValue = Int.random(in: 1...6)
    }
}
