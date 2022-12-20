//
//  OptionButton.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic on 12/19/22.
//

import SwiftUI

struct OptionButton: View {
    let title: String
    let action: () -> Void
    let isSelected: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isSelected == true
                                 ? Color.backgroundColor
                                 : Color.blue)
                .padding([.leading, .trailing], 4)
                .minimumScaleFactor(0.8) // Allows text to reduce in size
                .frame(maxWidth: 150)
                .frame(height: 60)
                .background(isSelected == true
                            ? Color.blue
                            : Color.backgroundColor)
                .cornerRadius(12)
        }
    }
}

struct OptionButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionButton(title: "Multiple Choice", action: {}, isSelected: true)
    }
}
