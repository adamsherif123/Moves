//
//  AddEmailView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI
import PhotosUI

struct SignUpFlowView: View {
    
    @Binding var textComponent: String
    @Binding var month: String
    @Binding var day: String
    @Binding var year: String
    @Binding var isMale: Bool
    @Binding var isFemale: Bool
    @Binding var isOther: Bool
    let isPassword: Bool
    let isImageShowing: Bool
    let title: String
    let subtitle: String
    let textFieldPlaceholder: String
     
    @EnvironmentObject var viewModel: RegistrationViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case month, day, year
    }
    
    init(
        textComponent: Binding<String>,
        isPassword: Bool,
        isImageShowing: Bool,
        title: String,
        subtitle: String,
        textFieldPlaceholder: String
    ) {
        self._textComponent = textComponent
        self.isPassword = isPassword
        self.isImageShowing = isImageShowing
        self.title = title
        self.subtitle = subtitle
        self.textFieldPlaceholder = textFieldPlaceholder
        
        self._month = .constant("")
        self._day   = .constant("")
        self._year  = .constant("")
        
        self._isMale = .constant(false)
        self._isFemale   = .constant(false)
        self._isOther  = .constant(false)
        
        
    }
    
    init(
        textComponent: Binding<String>,
        isPassword: Bool,
        isImageShowing: Bool,
        title: String,
        subtitle: String,
        textFieldPlaceholder: String,
        month: Binding<String>,
        day: Binding<String>,
        year: Binding<String>,
        isMale: Binding<Bool>,
        isFemale: Binding<Bool>,
        isOther: Binding<Bool>
    ) {
        self._textComponent = textComponent
        self.isPassword = isPassword
        self.isImageShowing = isImageShowing
        self.title = title
        self.subtitle = subtitle
        self.textFieldPlaceholder = textFieldPlaceholder
        
        self._month = month
        self._day   = day
        self._year  = year
        
        self._isMale = isMale
        self._isFemale = isFemale
        self._isOther  = isOther
    }
    
    
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            if isImageShowing {
                PhotosPicker(selection: $viewModel.selectedImage) {
                    if let image = viewModel.profileImage {
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.white)
                            .background(.gray)
                            .clipShape(Circle())
                    } else {
                        VStack {
                            ZStack {
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(Color(.systemGray4))
                                
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top)
                            
                            Text("Add profile picture")
                                .foregroundStyle(.blue)
                                .font(.footnote)
                                .padding(.top, 8)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            
            if isPassword {
                SecureField(textFieldPlaceholder, text: $textComponent)
                    .modifier(TextFieldModifier())
                    .padding(.top)
            } else if isImageShowing {
                VStack(alignment: .leading) {
                    TextField(textFieldPlaceholder, text: $textComponent)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                        .padding(.vertical)
                    
                    Text("Date of birth")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                        .padding(.horizontal, 24)
                    
                    HStack {
                        TextField("MM", text: $month)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .month)
                            .onChange(of: month) { oldValue, newValue in
                                if newValue.count > 2 {
                                    month = String(newValue.prefix(2))
                                } else if newValue.count == 2 {
                                    focusedField = .day
                                }
                            }
                            .modifier(TextFieldModifier())
                        
                        TextField("DD", text: $day)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .day)
                            .onChange(of: day) { oldValue, newValue in
                                if newValue.count > 2 {
                                    day = String(newValue.prefix(2))
                                } else if newValue.count == 2 {
                                    focusedField = .year
                                }
                            }
                            .modifier(TextFieldModifier())
                        
                        TextField("YYYY", text: $year)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .year)
                            .onChange(of: year) { oldValue, newValue in
                                if newValue.count > 4 {
                                    year = String(newValue.prefix(4))
                                }
                            }
                            .modifier(TextFieldModifier())
                    }
                    
                    Text("Gender")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    
                    HStack {
                        Button {
                            isMale = true
                            isOther = false
                            isFemale = false
                        } label: {
                            Text("Male")
                                .foregroundStyle(isMale ? .white : .black)
                                .font(.caption)
                                .frame(width: 80, height: 25)
                                .background(isMale ? .purple : Color(.systemGray5))
                                .clipShape(Rectangle()).cornerRadius(10)
                            
                        }
                        
                        Button {
                            isMale = false
                            isOther = false
                            isFemale = true
                        } label: {
                            Text("Female")
                                .foregroundStyle(isFemale ? .white : .black)
                                .font(.caption)
                                .frame(width: 80, height: 25)
                                .background(isFemale ? .purple : Color(.systemGray5))
                                .clipShape(Rectangle()).cornerRadius(10)
                            
                        }
                        
                        Button {
                            isMale = false
                            isOther = true
                            isFemale = false
                        } label: {
                            Text("Other")
                                .foregroundStyle(isOther ? .white : .black)
                                .font(.caption)
                                .frame(width: 80, height: 25)
                                .background(isOther ? .purple : Color(.systemGray5))
                                .clipShape(Rectangle()).cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                }
            } else {
                TextField(textFieldPlaceholder, text: $textComponent)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                    .padding(.top)
            }
        }
    }
}

#Preview {
    ImageAndFullnameView()
}
