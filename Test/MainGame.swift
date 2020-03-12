//
//  Main.swift
//  Liar's Dice
//
//  Created by Tommaso Parisotto on 28/02/2020.
//  Copyright © 2020 CogMod. All rights reserved.
//

import Foundation

public class MainGame
{
    enum State {
        case start
        case playerTurn
        case opponentTurn
        case liar
        case finished
        case error
    }
    enum CurrentPlayer : CaseIterable {
        case player
        case opponent
    }
    
    var gamestate : State
    var game : Game
    var currentPlayer : CurrentPlayer
    var firstTurn : Bool
    var liarThreshold : Double

    
    init()
    {
        gamestate = .start
        game = Game()
        currentPlayer = .player
        firstTurn = true
        liarThreshold = 0.4
    }
    
    func play()
    {
        mainloop: while self.gamestate != .finished
        {
            switch gamestate {
            
                
            case .start:
                print("[INFO] The round is started.")
                print("[INFO] Rolling the dice.")
                game.roll()
                game.currentBidRoll = 1
                game.currentBidNumber = 0
                var answerAccepted = false
                switch currentPlayer {
                case .player:
                    gamestate = .playerTurn
                    print("[INFO] Player starts.")
                case .opponent:
                    gamestate = .opponentTurn
                    print("[INFO] Opponent starts.")
                }
                

            case .playerTurn:
                print("Your hand is:")
                print(game.getPlayerHand())
                print("[INFO] Bidding phase.")
                
                // TODO: update with link to GUI
                var bidAccepted = false
                var answerAccepted = false
                
                if firstTurn == true
                {
                    answerAccepted = true
                    firstTurn = false
                }
                while (!answerAccepted)
                {
                    print("Do you want to call the opponent a liar?")
                    if let answer = readLine()
                    {
                        let answer_lc = answer.lowercased()
                        if answer_lc == "yes"
                        {
                            gamestate = .liar
                            answerAccepted = true
                        }
                        else if answer_lc == "no"
                        {
                            answerAccepted = true
                        }
                        else
                        {
                            print("[ERROR] Invalid answer.")
                        }
                    }
                    
                }
                while (!bidAccepted && gamestate == .playerTurn)
                {
                    print("Insert Roll bid:")
                    if let bidRoll = Int(readLine(strippingNewline: true)!)
                    {
                        print("Insert Number of dice bid:")
                        if let bidNum = Int(readLine(strippingNewline: true)!)
                        {
                            if game.bid(bidRoll: bidRoll, bidNumber: bidNum) < 0
                            {
                                continue
                            }
                            else
                            {
                                print(String(format:"[INFO] Player bids Roll: %i, Number %i", bidRoll, bidNum))
                                sleep(1)
                                bidAccepted = true
                            }
                        }
                        else
                        {
                            print("[ERROR] Invalid bid.")
                        }
                    }
                    else
                    {
                        print("[ERROR] Invalid bid.")
                    }
                }
                if gamestate != .liar
                {
                    currentPlayer = .opponent
                    gamestate = .opponentTurn
                }
                
                
                
            case .liar:
                switch currentPlayer {
                case .player:
                    print("[INFO] Player calls opponent a Liar.")
                    print("Player's hand:")
                    print(game.getPlayerHand())
                    print("Opponent's hand:")
                    print(game.getOpponentHand())
                    let (win, sumRoll, biddedRoll) = game.playerCallsLiar()
                    if win
                    {
                        print(String(format: "There are %i dice with roll %i.", sumRoll, biddedRoll))
                        sleep(1)
                        print("You lose the round. The opponent lost a dice.")
                    }
                    else
                    {
                        print(String(format: "There are %i dice with roll %i.", sumRoll, biddedRoll))
                        sleep(1)
                        print("You win the round. You lost a dice.")
                    }
                case .opponent:
                    print("[INFO] Opponent calls player a Liar.")
                    print("Player's hand:")
                    print(game.getPlayerHand())
                    print("Opponent's hand:")
                    print(game.getOpponentHand())
                    let (oppWin, sumRoll, biddedRoll) = game.opponentCallsLiar()
                    if !oppWin
                    {
                        print(String(format: "There are %i dice with roll %i.", sumRoll, biddedRoll))
                        sleep(1)
                        print("You win the round. You lost a dice.")
                    }
                    else
                    {
                        print(String(format: "There are %i dice with roll %i.", sumRoll, biddedRoll))
                        sleep(1)
                        print("You lost the round. Opponent lost a dice.")
                    }
                }
                if game.isOver() { gamestate = .finished }
                else { gamestate = .start }
                    
                
                
            case .opponentTurn:
                // TODO: implement model
                let probMatrix = computeProbabilityMatrix(hand: game.getOpponentHand(), diceInGame: game.diceInGame)
                print(String(format: "Probability of %d,%d is: %f", game.currentBidRoll, game.currentBidNumber, probMatrix[game.currentBidNumber][game.currentBidRoll-1]))
                if determineLiar(prob: probMatrix[game.currentBidNumber][game.currentBidRoll-1], threshold: liarThreshold)
                {
                    gamestate = .liar
                    continue mainloop
                }
                let bidRoll = Int.random(in: 1...6)
                let bidNum = game.currentBidNumber+1
                _ = game.bid(bidRoll: bidRoll, bidNumber: bidNum)
                print(String(format:"[INFO] Opponent bids Roll: %i, Number %i", bidRoll, bidNum))
                sleep(1)
                gamestate = .playerTurn
                
                
                
                
            case .finished:
                print("[INFO] The game has ended.")
                exit(0)
            case .error:
                print("[ERROR] Exit.")
                exit(0)
            
            }
        }
    }
    
    
    
}


