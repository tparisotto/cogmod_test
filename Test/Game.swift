//
//  Game.swift
//  Liar's Dice
//
//  Created by Tommaso Parisotto on 21/02/2020.
//  Copyright © 2020 CogMod. All rights reserved.
//

import Foundation

class Game
{
    var turnsPlayed: Int
    let player = Player()
    let opponent = Player()
    let players: [Player]
    var diceInGame: Int
    var currentBidRoll: Int
    var currentBidNumber: Int

    
    init()
    {
        turnsPlayed = 0
        player.rollHand()
        opponent.rollHand()
        diceInGame = player.hand.count + opponent.hand.count
        currentBidRoll = 0
        currentBidNumber = 0
        players = [player, opponent]
    }
    
    func bid(bidRoll: Int, bidNumber: Int) -> Int
    {
        if bidRoll < 1
        {
            print("[Error] Can't roll less than 1.")
            return -1
        }
        if bidRoll > 6
        {
            print("[Error] Can't roll more than 6.")
            return -1
        }
        
        if (bidNumber < currentBidNumber)
        {
            print("[Error] Can't bid less than previous turns.")
            return -1
        }
        else if (bidNumber == currentBidNumber)
        {
            if (bidRoll < currentBidRoll)
            {
                print("[Error] Can't bid a roll lower than previous turns.")
                return -1
            }
            else
            {
                currentBidNumber = bidNumber
                currentBidRoll = bidRoll
                turnsPlayed += 1
                return 1
            }
        }
        else
        {
            currentBidNumber = bidNumber
            currentBidRoll = bidRoll
            turnsPlayed += 1
            return 1
        }
    }
    
    func playerCallsLiar() -> (Bool,Int,Int)
    {
        var sumRolls = 0
        
        for pl in players
        {
            sumRolls += pl.getRollNumber(roll: currentBidRoll)
        }
        // player calls a wrong liar
        print(sumRolls)
        if currentBidNumber <= sumRolls
        {
            opponent.loseDice()
            return (false,sumRolls,currentBidRoll)
            
        }
        else
        {
            player.loseDice()
            return (true,sumRolls,currentBidRoll)
        }
    }
    
    func opponentCallsLiar() -> (Bool,Int,Int)
    {
        var sumRolls = 0
        
        for pl in players
        {
            sumRolls += pl.getRollNumber(roll: currentBidRoll)
        }
        if currentBidNumber <= sumRolls
        {
            player.loseDice()
            return (false,sumRolls,currentBidRoll)
        }
        else
        {
            opponent.loseDice()
            return (true,sumRolls,currentBidRoll)
        }
    }
    
    func getPlayerHand() -> [Int]
    {
        return player.getHand()
    }
    func getOpponentHand() -> [Int]
    {
        return opponent.getHand()
    }
    
    func isOver() -> Bool {
        if player.hand.count == 0 {return true}
        if opponent.hand.count == 0 {return true}
        return false
    }
    
    func roll()
    {
        for pl in players {pl.rollHand()}
    }
}
