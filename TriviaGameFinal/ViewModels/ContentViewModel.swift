//
//  ContentViewModel.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import Foundation

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var selectedCategory: String
        @Published var categories: Array<TriviaCategory>
        @Published var errorMessage: String = ""
        
        @Published var triviaOptionsActive: Bool = false
        @Published var rootActive: Bool = true 
        
        init() {
            selectedCategory = ""
            categories = []
        }
        
        public func setupCategories() async -> Void {
            if categories.count != 0 {
                return 
            }
            let serviceResponse = await TriviaService().fetchCategories()
            if serviceResponse.error != nil {
                errorMessage = serviceResponse.error!
                return
            }
            if serviceResponse.error != nil {
                self.errorMessage = serviceResponse.error!
            }
            categories = serviceResponse.categories
        }
        
        public func formatCategoryName(name: String) -> String {
            let formatted: String = name.replacingOccurrences(of: "Entertainment: ", with: "")
            return formatted
        }
        
    }
}
