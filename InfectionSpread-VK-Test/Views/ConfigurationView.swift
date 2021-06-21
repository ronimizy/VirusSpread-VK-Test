//
//  SwiftUIView.swift
//  InfectionSpread-VK-Test
//
//  Created by Георгий Круглов on 21.06.2021.
//

import SwiftUI

struct ConfigurationView: View {
    @State private var groupSize: Double = 50
    @State private var infectiouness: Double = 50
    @State private var deadlyness: Double = 2
    @State private var infectionFactor: Double = 3
    @State private var period: Double = 1
    @State private var width: Double = 7
    
    @State private var modelingIsPresented: Bool = false
        
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                HStack {
                    VStack {
                        VStack {
                            Text("Group Size: \(Int(groupSize))")
                            Slider(value: $groupSize, in: 1...10000, step: 1)
                                .padding(.horizontal)
                                .background(GeometryReader { proxy in
                                    VStack {
                                        HStack {
                                            Text("1")
                                            Spacer()
                                            Text("10000")
                                        }
                                        .font(.system(size: 12))
                                        .padding(.horizontal)
                                    }
                                })
                        }
                            
                        
                        VStack {
                            Text("Infectiouness (%): \(Int(infectiouness))")
                            Slider(value: $infectiouness, in: 0...100, step: 1)
                                .padding(.horizontal)
                                .background(GeometryReader { proxy in
                                    VStack {
                                        HStack {
                                            Text("0")
                                            Spacer()
                                            Text("100")
                                        }
                                        .font(.system(size: 12))
                                        .padding(.horizontal)
                                    }
                                })
                        }
                        
                        VStack {
                            Text("Deadlyness (%): \(Int(deadlyness))")
                            Slider(value: $deadlyness, in: 0...Double(groupSize), step: 1)
                                .padding(.horizontal)
                                .background(GeometryReader { proxy in
                                    VStack {
                                        HStack {
                                            Text("0")
                                            Spacer()
                                            Text(String(groupSize))
                                        }
                                        .font(.system(size: 12))
                                        .padding([.leading, .trailing])
                                    }
                                })
                        }
                        
                        VStack {
                            Text("Infection factor (%): \(Int(infectionFactor))")
                            Slider(value: $infectionFactor, in: 0...Double(groupSize), step: 1)
                                .padding(.horizontal)
                                .background(GeometryReader { proxy in
                                    VStack {
                                        HStack {
                                            Text("0")
                                            Spacer()
                                            Text(String(groupSize))
                                        }
                                        .font(.system(size: 12))
                                        .padding([.leading, .trailing])
                                    }
                                })
                        }
                        
                        VStack {
                            Text("Width: \(Int(width))")
                            Slider(value: $width, in: 0...Double(groupSize), step: 1)
                                .padding(.horizontal)
                                .background(GeometryReader { proxy in
                                    VStack {
                                        HStack {
                                            Text("0")
                                            Spacer()
                                            Text(String(groupSize))
                                        }
                                        .font(.system(size: 12))
                                        .padding([.leading, .trailing])
                                    }
                                })
                        }
                        
                        Text("Spread period (s):")
                        TextField("1", value: $period, formatter: NumberFormatter())
                            .padding(.leading)
                        
                        Spacer().frame(height: proxy.size.height * 0.3)
                        Button("Start Modeling") {
                            modelingIsPresented = true
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Rectangle()
                                .fill(Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)))
                                .cornerRadius(20, corners: [.bottomLeft, .bottomRight]))
                        
                    }
                    .navigationTitle("Virus Modeling")
                    .fullScreenCover(isPresented: $modelingIsPresented, content: {
                        ContentView(interval: period,
                                    size: Int(groupSize),
                                    columnCount: Int(min(groupSize, width)),
                                    infectiouness: Int(min(groupSize, infectiouness)),
                                    deadlyness: Int(min(groupSize, deadlyness)),
                                    factor: Int(min(groupSize, infectionFactor)))
                    })
                }
            }
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
