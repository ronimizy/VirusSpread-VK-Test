//
//  PopulationViewModel.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import SwiftUI

public class PopulationViewModel: ObservableObject, Sequence, RandomAccessCollection {
    public typealias Arr = [(Individual, () -> ())]
    
    public typealias Element = Arr.Element
    public typealias Index = Arr.Index
    public typealias SubSequence = Arr.SubSequence
    public typealias Indices = Arr.Indices
    
    @Published private var population: Population
    
    private var cycleQueue = DispatchQueue(label: "com.ronimizy.cycle", attributes: .concurrent)
    
    public var healthy: Int {
        population.filter({ $0.state == .healthy }).count
    }
    public var infected: Int {
        population.filter({ $0.state == .infected }).count
    }
    public var deceased: Int {
        population.filter({ $0.state == .deceased }).count
    }
    public var width: Int {
        population.width
    }
    public var count: Int {
        population.count
    }
    public var cycleCount: Int = 0
    
    public var startIndex: Arr.Index
    public var endIndex: Arr.Index
    
    
    init(_ population: Population) {
        self.population = population
        self.startIndex = 0
        self.endIndex = population.count - 1
    }
    
    public subscript(position: Arr.Index) -> Arr.Element {
        get {
            (individual: population[position], action: tapAction(for: position))
        }
    }
    
    
    public func makeIterator() -> Arr.Iterator {
        return population.makeIterator().enumerated().map { (individual: $1, action: tapAction(for: $0)) }.makeIterator()
    }
    
    public func tapAction(for i: Int) -> () -> () {
        return {
            DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
                    switch self?.population[i].state {
                    case .healthy:
                        self?.population[i].infect(with: self?.population.virus)
                    case .infected:
                        self?.population[i].state = .deceased
                    default:
                        ()
                    }
            }
        }
    }
    
    public func spreadCycle() {
        cycleQueue.async(qos: .background) { [weak self] in
            let group = DispatchGroup()
            var infectedIndices: [Int] = []
            let lock = NSLock()
            
            if self?.healthy != 0 ,
               let population = self?.population {
                for carrier in population
                                .enumerated()
                                .filter({ $0.element.state != .healthy })
                                .map({ $0.offset }) {
                    self?.cycleQueue.async { [weak self] in
                        group.enter()
                        let people = self?.population.infectFrom(i: carrier) ?? []
                        lock.lock()
                        infectedIndices.append(contentsOf: people)
                        lock.unlock()
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: DispatchQueue.main) { [weak self] in
                for index in infectedIndices {
                    self?.population[index].infect(with: self?.population.virus)
                }
                for index in self?.population.enumerated()
                    .filter({ $0.element.state == .infected })
                    .map({ $0.offset }) ?? [] {
                    self?.population[index].suffer()
                }
            }
        }
    }
}
