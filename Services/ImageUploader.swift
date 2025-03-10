//
//  ImageUploader.swift
//  Moves
//
//  Created by Adam Sherif on 3/3/25.
//

import Foundation
import UIKit
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return "" }
        print("DEBUG: Image data is \(imageData)")
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath:  "/profileImages/\(filename)")
        print("DEBUG: Ref is \(ref)")
        
        do {
            print("DEBUG: Starting image upload")
            let _ = try await ref.putDataAsync(imageData)
            print("DEBUG: Image uploaded successfully")
            let url = try await ref.downloadURL()
            print("DEBUG: Download URL obtained: \(url.absoluteString)")
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image: \(error.localizedDescription)")
            return ""
        }
    }
}
