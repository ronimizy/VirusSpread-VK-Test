//
//  ContentView.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 16.06.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var populationViewModel: PopulationViewModel
    @State private var scale: CGFloat = 1
    @Environment(\.presentationMode) var presentationMode
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private var cycleCount: Int {
        populationViewModel.cycleCount
    }
    
    private let cellSize: CGFloat = 50
    private let spacing: CGFloat = 20
    private let columnCount: Int
    
    private let fontSize: CGFloat = 60
    
    private let maxScale: CGFloat = 1.5
    private let minScale: CGFloat = 0.5
    
    
    init(interval: Double, size: Int, columnCount: Int, infectiouness: Int, deadlyness: Int, factor: Int) {
        self.columnCount = columnCount
        self._populationViewModel = StateObject(wrappedValue: PopulationViewModel(Population(size: size,
                                                                                             width: columnCount,
                                                                                             virus: Virus(infectiouness: infectiouness,
                                                                                                          deadlyness: deadlyness,
                                                                                                          factor: factor))))
        self.timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        if populationViewModel.healthy != 0 {
                            HStack {
                                Text("\(populationViewModel.healthy)")
                                    .foregroundColor(.states.healthy)
                                    .font(.system(size: 50))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .frame(width: proxy.size.width / 3)
                                    .frame(height: fontSize)
                                    .padding(.leading, 2 * spacing)
                                Spacer()
                            }
                        }
                        
                        if populationViewModel.infected != 0 {
                            Text("\(populationViewModel.infected)")
                                .foregroundColor(.states.infected)
                                .font(.system(size: 50))
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .frame(width: proxy.size.width / 3)
                                .frame(height: fontSize)
                        }
                        
                        if populationViewModel.deceased != 0 {
                            HStack {
                                Spacer()
                                Text("\(populationViewModel.deceased)")
                                    .foregroundColor(.states.deceased)
                                    .font(.system(size: 50))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .frame(width: proxy.size.width / 3)
                                    .frame(height: fontSize)
                                    .padding(.trailing, 2 * spacing)
                            }
                        }
                    }
                    
                    ScrollView([.vertical, .horizontal], showsIndicators: false) {
                        PopulationView(size: cellSize, spacing: spacing, columnCount: columnCount)
                            .environmentObject(populationViewModel)
                            .scaleEffect(scale)
                    }
                    .onReceive(timer, perform: { _  in
                        self.populationViewModel.spreadCycle()
                        self.populationViewModel.cycleCount += 1
                        self.populationViewModel.objectWillChange.send()
                    })
                    .gesture(MagnificationGesture()
                                        .onChanged({ scale in
                                            self.scale = min(scale, maxScale)
                                            self.scale = max(self.scale, minScale)
                                        }))
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button("Quit") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.white)
                        .frame(width: proxy.size.width * 0.2,
                               height: proxy.size.height * 0.03)
                        .padding(0.5 * spacing)
                        .background(
                            Rectangle()
                                .fill(Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))))
                                .cornerRadius(25, corners: [.topLeft, .bottomRight])
                        
                        Spacer().frame(width: 1.5 * spacing)
                    }
                }
            }
            .background(
                Text(String(cycleCount))
                    .font(.system(size: proxy.size.width / 1.5))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding()
                    .frame(width: proxy.size.width)
                    .foregroundColor(.gray)
                    .opacity(0.5))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(interval: 1,
                    size: 200, columnCount: 10,
                    infectiouness: 50, deadlyness: 5, factor: 3)
    }
}
