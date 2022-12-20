//
//  Extensions.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic on 12/19/22.
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
