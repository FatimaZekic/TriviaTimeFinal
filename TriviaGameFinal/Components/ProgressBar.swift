//
//  ProgressBar.swift
//  TriviaGameFinal
//
//  Created by Fatima Zekic, Noor EL-Hawwat, and Vithika Shah.
//

import SwiftUI

struct ProgressBar: View {
    let percentComplete: Double
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    GeometryReader { innerGeometry in
                        RoundedRectangle(cornerRadius: 12) // Frame updated
                            .fill(Color.blue)
                            .frame(width: innerGeometry.size.width * percentComplete)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                    }
                }
                .frame(width: geometry.size.width * 0.85) // 85% of screen
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray)
                }
                .frame(width: geometry.size.width) // Centered
            }
        }
        .frame(height: 10)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(percentComplete: 0.5)
    }
}
