//
//  Population.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import Foundation

struct Population: Sequence {
    private struct Node {
        public var individual: Individual
        public var adjacency: [Int]
    }
    
    private var graph: [Node] = []
    public let virus: Virus
    
    private var root: Int
    public let width: Int
    public var count: Int {
        graph.count
    }
    
    public subscript(i: Int) -> Individual {
        get {
            graph[i].individual
        }
        set {
            graph[i].individual = newValue
        }
    }
    
    init(size: Int, width: Int, virus: Virus) {
        self.width = width
        self.root = width * width / 2 + width / 2
        self.virus = virus
        
        for i in 0..<size {
            var adjacency: [Int] = []
            
            if (i - 1 + width) % width == i % width - 1 {
                adjacency.append(i - 1)
            }
            if (i + 1) % width == i % width + 1 && i + 1 < size {
                adjacency.append(i + 1)
            }
            if i - width >= 0 {
                adjacency.append(i - width)
            }
            if i + width < size {
                adjacency.append(i + width)
            }
            
            graph.append(Node(individual: Individual(immunity: Int.random(in: 0...100),
                                                     state: .healthy),
                              adjacency: adjacency))
        }
    }
    
    public func infectFrom(i: Int) -> [Int] {
        var queue: [(index: Int, distance: Int)] = []
        var visited: [Bool] = Array(repeating: false, count: graph.count)
        var infected: [Int] = []
        
        queue.append((i, 0))
        visited[i] = true
        
        while !queue.isEmpty && infected.count != virus.factor {
            let (index, distance) = queue.first!
            queue.removeFirst()
            
            if distance >= virus.factor * 2 {
                return infected
            }
            
            for adj in graph[index].adjacency.filter( { !visited[$0] }) {
                if infected.count == virus.factor {
                    break
                }
                
                if graph[adj].individual.state == .healthy && graph[adj].individual.engage(with: graph[index].individual) {
                    infected.append(adj)
                }
                queue.append(contentsOf: graph[adj].adjacency
                                .filter( { !visited[$0] })
                                .map({ ($0, distance + 1) }))
                visited[adj] = true
            }
        }
        
        return infected
    }
    
    public func makeIterator() -> Array<Individual>.Iterator {
        return graph.map { $0.individual }.makeIterator()
    }
}
