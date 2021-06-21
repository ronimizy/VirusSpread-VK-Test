//
//  Virus.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import Foundation

public struct Virus: Hashable {
    public let id = UUID()
    
    public let infectiouness: Int
    public let deadlyness: Int
    public let factor: Int
}
