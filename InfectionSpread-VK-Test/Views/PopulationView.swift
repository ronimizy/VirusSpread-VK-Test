//
//  PopulationView.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import SwiftUI

struct PopulationView: View {
    @EnvironmentObject private var populationViewModel: PopulationViewModel
    
    private var size: CGFloat
    private let spacing: CGFloat
    private let columnCount: Int

    
    init(size: CGFloat, spacing: CGFloat, columnCount: Int) {
        self.size = size
        self.spacing = spacing
        self.columnCount = columnCount
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(size)),
                                 count: columnCount),
                  spacing: spacing) {
            
            ForEach(populationViewModel, id: \.0.self) { (individual, action) in
                IndividualView(individual: individual, tapAction: action)
                    .frame(width: size, height: size)
            }
        }.ignoresSafeArea(.container, edges: .all)
    }
}
