//
//  LocationSearchResultCell.swift
//  Moves
//
//  Created by Adam Sherif on 3/7/25.
//

import SwiftUI

struct LocationSearchResultCell: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.purple)
                .accentColor(.white)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
            
        }
        .padding(.leading)
    }
}

#Preview {
    LocationSearchResultCell(title: "Starbacks", subtitle: "123 Main st")
}
