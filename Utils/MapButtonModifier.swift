//
//  ButtonModifier.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import Foundation
import SwiftUI

struct MapButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundStyle(.black)
            .padding(9)
            .background(.white)
            .clipShape(Circle())
            .shadow(radius: 6)
    }
    
}
