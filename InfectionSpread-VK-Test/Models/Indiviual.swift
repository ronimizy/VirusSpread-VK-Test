//
//  Indiviual.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import Foundation

public struct Individual: Hashable {
    public let id = UUID()
    
    public var health: Int = 100
    public var immunity: Int
    
    public var state: MedicalState
    private var virus: Virus? = nil
    
    public init(immunity: Int, state: MedicalState) {
        self.immunity = immunity
        self.state = state
    }
    
    public func engage(with rhs: Individual) -> Bool {
        let coefficient: Int
        
        switch rhs.state {
        case .infected:
            coefficient = 1
        case .deceased:
            coefficient = 2
        default:
            return false
        }
        
        if state == .deceased {
            return false
        }
        
        guard let virus = rhs.virus else {
            return false
        }
        
        let immunity = Int.random(in: 0...immunity)
        let infectiouness = Int.random(in: 0...coefficient * virus.infectiouness)
        
        return immunity <= infectiouness
    }
    
    public mutating func suffer() {
        if state != .infected {
            return
        }
        
        health -= virus?.deadlyness ?? 0
        if health <= 0 {
            state = .deceased
        }
    }
    
    public mutating func infect(with: Virus?) {
        guard let with = with else {
            return
        }
        
        virus = with
        state = .infected
    }
}
