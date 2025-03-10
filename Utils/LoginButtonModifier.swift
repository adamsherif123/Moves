//
//  LoginButtonModifier.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

public struct LoginButtonModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color.white)
            .frame(width: 360, height: 44)
            .background(.purple)
            .cornerRadius(10)
    }
}
