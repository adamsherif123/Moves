//
//  CodeViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/11/25.
//

import Foundation
import FirebaseFirestore

class CodeViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var generatedCode: String = ""
    @Published var statusMessage: String = ""
    private var circleId: String = ""
    
    @MainActor
    func generateCode() async throws {
        let maxAttempts = 20
        var attempts = 0
        var codeAlreadyExists = true
        var newCode = ""
        
        while codeAlreadyExists && attempts < maxAttempts {
            attempts += 1
            
            newCode = randomCode(length: 6)
            
            let query = Firestore.firestore()
                .collection("circles")
                .whereField("code", isEqualTo: newCode)
            
            let snapshot = try await query.getDocuments()
            
            codeAlreadyExists = !snapshot.documents.isEmpty
        }
        
        guard codeAlreadyExists == false else { return }
        
        self.generatedCode = newCode
        
        code = ""
        statusMessage = ""
        
        var code = [String: Any]()
        
        code["code"] = newCode
        
        try await Firestore.firestore()
            .collection("circles")
            .document(self.circleId)
            .updateData(code)
    }
    
    func checkCode() {
        if code.lowercased() == generatedCode.lowercased() {
            statusMessage = "Correct code"
        } else {
            statusMessage = "Incorrect code"
        }
    }
    
    private func randomCode(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
    
    func createCircle() async throws {
        let circleId = NSUUID().uuidString
        self.circleId = circleId
        let circle = Circles(id: circleId)
        guard let encodedCircle = try? Firestore.Encoder().encode(circle) else { return }
        
        try? await Firestore.firestore().collection("circles").document(circleId).setData(encodedCircle)
    }
    
}
