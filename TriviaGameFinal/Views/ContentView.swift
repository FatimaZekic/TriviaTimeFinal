//
//  ContentView.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic on 12/19/22.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea([.all])
            NavigationView {
                ZStack {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.categories, id:\.id) { category in
                                NavigationLink(destination: TriviaOptionsView(triviaCategory: category)) {
                                    GeometryReader { geometry in
                                        HStack() {
                                            Text(viewModel.formatCategoryName(name: category.name))
                                                .font(.system(size: 26, weight: .bold))
                                                .foregroundColor(Color.backgroundColor)
                                                .padding()
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                        }
                                        .frame(width: geometry.size.width * 0.85, height: 100)
                                        .background(Color.blue)
                                        .cornerRadius(15)
                                        .frame(width: geometry.size.width) // Horizontally centered
                                    }
                                    .frame(height: 100)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Trivia Time")
                }
                .onAppear {
                    Task {
                        await viewModel.setupCategories()
                    }
                }
            } // NavigationView
            .navigationViewStyle(.stack) // Prevents constraint error
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

