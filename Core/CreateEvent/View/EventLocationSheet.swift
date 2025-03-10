//
//  EventLocationSheet.swift
//  Moves
//
//  Created by Adam Sherif on 3/7/25.
//

import SwiftUI

struct EventLocationSheet: View {
    
    @ObservedObject var locationSearchViewModel = LocationSearchViewModel.shared
    @EnvironmentObject var viewModel: CreateEventViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundStyle(.purple)
                            .imageScale(.large)
                    }
                    
                    Spacer()
                    
                    Text("Enter event location")
                        .font(.headline)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
                .padding(.bottom)
                
                HStack {
                    VStack {
                        TextField("📍Search here", text: $locationSearchViewModel.queryFragmnet)
                            .padding(8)
                            .modifier(Modifierr())
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(locationSearchViewModel.results, id: \.self) { result in
                            LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                                .onTapGesture {
                                    locationSearchViewModel.selectLoction(result)
                                    viewModel.titleOfLocation = result.title
                                    dismiss()
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EventLocationSheet()
}
