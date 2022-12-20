//
//  Category.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import Foundation

class TriviaCategory: Decodable {
    private(set) var id: Int
    private(set) var name: String
    
    init() {
        self.id = 1
        self.name = "Sample"
    }
}

class TriviaCategories: Decodable {
    private(set) var trivia_categories: Array<TriviaCategory>
    
    init() {
        self.trivia_categories = []
    }
}
