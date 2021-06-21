//
//  IndividualView.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import SwiftUI

struct IndividualView: View {
    @State private var individual: Individual
    private var tapAction: () -> ()
    
    private static let colors: [MedicalState : Color] = [
        .healthy : Color.states.healthy,
        .infected : Color.states.infected,
        .deceased : Color.states.deceased
    ]
    
    init(individual: Individual, tapAction: @escaping () -> ()) {
        self._individual = State(initialValue: individual)
        self.tapAction = tapAction
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .fill(Self.colors[individual.state] ?? Color.white)
                Circle()
                    .fill((Self.colors[individual.state] ?? Color.black))
                    .brightness(0.8)
                    .frame(width: proxy.size.width * 0.8,
                           height: proxy.size.height * 0.8)
                Circle()
                    .fill((Self.colors[individual.state] ?? Color.white))
                    .frame(width: proxy.size.width * 0.6,
                           height: proxy.size.height * 0.6)
                    
            }.onTapGesture {
                tapAction()
            }
        }
    }
}

struct IndividualView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualView(individual: Individual(immunity: 50, state: .healthy), tapAction: { () })
    }
}
