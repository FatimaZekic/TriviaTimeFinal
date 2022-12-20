//
//  TriviaService.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import Foundation

class TriviaService {
    public func fetchTriviaQuestions(difficulty: Difficulty, category: TriviaCategory, triviaType: TriviaType, quantity: Int) async -> (questions: Array<Question>, error: String?) {
        var urlString: String = "https://opentdb.com/api.php?amount=\(quantity)&category=\(category.id)"
        if difficulty != Difficulty.any {
            urlString += "&difficulty=\(difficulty.rawValue)"
        }
        
        if triviaType != TriviaType.both {
            urlString += "&type=\(triviaType.rawValue)"
        }
        urlString += "&encode=base64"

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (dataResponse, urlResponse) = try await URLSession.shared.data(for: request)
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                return ([], "Server response error.")
            }
            if httpUrlResponse.statusCode != 200 {
                return ([], "Error: \(httpUrlResponse.statusCode)")
            }
            guard let decodedData = try? JSONDecoder().decode(QuestionsDecodable.self, from: dataResponse) else {
                return ([], "An error occured obtaining trivia questions.")
            }
            if decodedData.response_code == 1 {
                return ([], "Not enough questions in database")
            } else if decodedData.response_code != 0 {
                return ([], "Error initializing game")
            }
            print("Successfully fetched trivia questions")
            for question in decodedData.results {
                question.decodeBase64Strings()
            }
            return (decodedData.results, nil)
        } catch let error {
            print(error.localizedDescription)
            return ([], error.localizedDescription)
        }
    }
    
    public func fetchCategories() async -> (categories: Array<TriviaCategory>, error: String?) {
        let apiURL = URL(string: "https://opentdb.com/api_category.php")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (dataResponse, urlResponse) = try await URLSession.shared.data(for: request) // URLResponse is not needed
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                return ([], "Server response error.")
            }
            if httpUrlResponse.statusCode != 200 {
                return ([], "Error: \(httpUrlResponse.statusCode)")
            }
            guard let decodedData = try? JSONDecoder().decode(TriviaCategories.self, from: dataResponse) else {
                print("Decode error")
                return ([], "Error occured obtaining categories.")
            }
            print("Successfully fetched category data.")
            return (decodedData.trivia_categories, nil)
            
        } catch let error {
            print(error.localizedDescription)
            return ([], error.localizedDescription)
        }
    }
}

