//
//  Extensions.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import SwiftUI

extension Color {
    public static let backgroundColor = Color("BackgroundColor")
    public static let contrastColor = Color("ContrastColor")
}

extension String {
    func base64Decode() -> String? {
        if let data = Data(base64Encoded: self, options: [.ignoreUnknownCharacters]) {
            return String(data: data, encoding: .utf16)
        }
        return nil
    }
}
