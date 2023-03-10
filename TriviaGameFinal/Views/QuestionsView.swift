//
//  QuestionsView.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import SwiftUI

// AnswerBox

// A box of the answer
fileprivate struct AnswerBox: View {
    let possibility: Answer
    @Binding var selectedUUID: UUID // Relays to QuestionView of selection is incorrect / correct
    @Binding var clickedComplete: Bool
    @Binding var selectionCorrect: Bool
    
    @State private var wasSelected: Bool = false // Highlights only the selected box
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Button(action: {
                    if possibility.incorrect == false {
                        selectionCorrect = true
                    }
                    withAnimation(.easeOut(duration: 0.1)) {
                        clickedComplete = true
                        wasSelected = true
                    }
                }) {
                    Text(possibility.text)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.black)
                        .minimumScaleFactor(0.5)
                        .padding()
                        .frame(width: geometry.size.width * 0.9, height: 60)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.7), radius: 2)
                        }
                        .overlay(alignment: .trailing) {
                            if wasSelected == true {
                                Image(systemName: clickedComplete == true && possibility.incorrect == false ? "checkmark" : "xmark")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                }
                .background(markCorrect())
                .cornerRadius(12)
                .frame(width: geometry.size.width) // Centers the ZStack
            }
            .frame(height: 60)
        }
    }
    
    func markCorrect() -> Color {
        if clickedComplete == true && possibility.incorrect == false { // Correct; display correct unconditionally
            return Color.green // Green color after clicked complete
        }
        
        if wasSelected == true && possibility.incorrect == true { // Incorrect button selected
            return Color.red // Red if incorrect
        }
        
        return Color.white // White when not selected
    }
}

// QustionView

// Displays a singular question and relays back to QuestionsView once selected
fileprivate struct QuestionView: View {
    // Required params:
    let question: String
    let possibilities: Array<Answer>
    @Binding var clicked: Bool
    @Binding var selectionCorrect: Bool
    
    @State private var selectedUUID = UUID()
    
    var body: some View {
        ZStack {
            VStack {
                Text(question)
                    .font(.system(size: 24, weight: .medium))
                    .padding()
                
                VStack(spacing: 30) {
                    ForEach(possibilities, id: \.uuid) { possibility in
                        AnswerBox(possibility: possibility, selectedUUID: $selectedUUID, clickedComplete: $clicked, selectionCorrect: $selectionCorrect)
                            .disabled(clicked)
                    }
                }
            }
        }
    }
}




// QuestionsView

// View that controls which question to be displayed and redirects to result screen.
struct QuestionsView: View {
    @StateObject private var viewModel = ViewModel()
    
    @Binding var questions: Array<Question>
   
    @State var currentQuestionIndex: Int = 0
    @State var possibilities: Array<Answer> = []
    @State var clicked: Bool = false // Determines if an option was clicked
    @State var selectionCorrect: Bool = false
    @State var displayResults: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if displayResults == false {
                        Text("\(questions[currentQuestionIndex].category)")
                    }
                    Spacer()
                    Text("\(currentQuestionIndex + 1) / \(questions.count)")
                }
                
                .font(.system(size: 24, weight: .bold))
                .padding()
                
                ProgressBar(percentComplete: Double(currentQuestionIndex + 1) / Double(questions.count))
                if displayResults == false {
                    resultsView()
                } else {
                    triviaQuizView()
                }
                
                Spacer()
            }
            .onAppear {
                possibilities = viewModel.initPossiblities(question: questions[currentQuestionIndex])
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func nextClicked() {
        if selectionCorrect == true {
            viewModel.correctCount += 1
        } else {
            viewModel.incorrectCount += 1
        }
        if currentQuestionIndex + 1 >= questions.count {
            displayResults = true
            return // Do not update
        }
        currentQuestionIndex += 1
        clicked = false
        selectionCorrect = false
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        viewModel.correctCount = 0
        viewModel.incorrectCount = 0
        displayResults = false
        clicked = false
        possibilities = viewModel.initPossiblities(question: questions[currentQuestionIndex]) // Re-initialize
    }
    
    @ViewBuilder
    func resultsView() -> some View {
        QuestionView(question: questions[currentQuestionIndex].question, possibilities: possibilities, clicked: $clicked, selectionCorrect: $selectionCorrect)
            .onChange(of: currentQuestionIndex) { _ in
                possibilities = viewModel.initPossiblities(question: questions[currentQuestionIndex])
            }
        if clicked {
            Button(action: {
                nextClicked()
            }) {
                Text("Next")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.backgroundColor)
                    .frame(width: 150, height: 60)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding([.top], 30)
            }
        }
    }
    
   @ViewBuilder
    func triviaQuizView() -> some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading) {
                if Double(viewModel.correctCount) / Double(questions.count) >= 0.8 {
                    Text("Awesome ????!\n\nYou got \(viewModel.correctCount) out of \(questions.count) questions right!")
                } else if Double(viewModel.correctCount) / Double(questions.count) >= 0.5 {
                    Text("Good job!\n\nYou got \(viewModel.correctCount) out of \(questions.count) questions right!")
                } else {
                    Text("You got \(viewModel.correctCount) out of \(questions.count) questions right!\n\n")
                }
            }
            Button(action: restartGame) {
                Text("Try again!")
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 200, height: 50)
                    .foregroundColor(Color.backgroundColor)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Button(action: {
                self.dismiss()
            }) {
                Text("Back")
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 200, height: 50)
                    .foregroundColor(Color.backgroundColor)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        } 
        .font(.system(size: 28, weight: .medium))
        .padding([.top], 50)
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuestionsView(questions: .constant([Question(), Question(), Question()]))
        }
    }
}
