//
//  View+Shadow.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

extension View {
    func customShadowStyle() -> some View {
        self
            .foregroundStyle(
                .black.opacity(0.2)
                .shadow(
                    .inner(color: .white.opacity(0.3), radius: 10, x: -5, y: -10)
                )
                .shadow(
                    .inner(color: .black.opacity(0.3), radius: 10, x: 10, y: 10)
                )
                .shadow(
                    .drop(color: .white.opacity(0.3), radius: 3, x: -3, y: -3)
                )
                .shadow(
                    .drop(color: .black.opacity(0.3), radius: 4, x: 7, y: 7)
                )
            )
    }
}
