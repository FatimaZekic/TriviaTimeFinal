//
//  TriviaOptionsViewModel.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import Foundation
import SwiftUI

extension TriviaOptionsView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var selectedDifficulty: Difficulty
        @Published var selectedType: TriviaType
        @Published var numberOfQuestions: Int

        @Published var errorMessage: String = ""
        
        @Published var questions: Array<Question> = []
        
        @Published var successfulLoad: Bool = false

        
        private let updateAnimation = Animation.easeOut(duration: 0.25)
        
        init() {
            self.selectedDifficulty = .any
            self.selectedType = .both
            self.numberOfQuestions = 10
        }

        public func updateDifficulty(selected: Difficulty) {
            withAnimation(updateAnimation) {
                self.selectedDifficulty = selected
            }
        }
        
        public func updateTriviaType(selected: TriviaType) {
            withAnimation(updateAnimation) {
                self.selectedType = selected
            }
        }
        
        public func updateQuantity(selected: Int) {
            withAnimation(updateAnimation) {
                self.numberOfQuestions = selected
            }
        }
        
        public func isDifficultyActive(_ difficulty: Difficulty) -> Bool {
            if difficulty == self.selectedDifficulty {
                return true
            }
            return false
        }
        
        public func isTriviaTypeActive(_ triviaType: TriviaType) -> Bool {
            if triviaType == self.selectedType {
                return true
            }
            return false
        }
        
        
        public func isQuantitySelected(_ number: Int) -> Bool {
            if number == self.numberOfQuestions {
                return true
            }
            return false
        }
        
        public func fetchTriviaQuestions(triviaCategory: TriviaCategory) async -> Void {
            let (questions, error) = await TriviaService().fetchTriviaQuestions(
                difficulty: self.selectedDifficulty,
                category: triviaCategory,
                triviaType: self.selectedType,
                quantity: self.numberOfQuestions
            )
            if error != nil {
                print("Error getting data.")
                errorMessage = error!
                return
            }
            if questions.count == 0 {
                errorMessage = "Error."
                return
            }
            print("Successfully obtained data.")
            self.questions = questions // Proceed to Question
            self.successfulLoad = true
        }
        
    }
}
