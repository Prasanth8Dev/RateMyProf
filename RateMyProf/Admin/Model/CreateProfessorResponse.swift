//
//  CreateProfessorResponse.swift
//  RateMyProf
//
//  Created by Harini S on 21/01/25.
//

import Foundation
import UIKit

// Model for the professor with necessary properties
struct NewProfessor: Codable {
    let firstName: String
    let lastName: String
    let title: String
    let university: String
    let department: String
    let email: String
    let phoneNumber: String
    let username: String
    let password: String
    var profilePic: String? // Store profilePic as a base64 encoded string
    
    // Custom initializer to encode profilePic as base64 if it's provided
    init(firstName: String, lastName: String, title: String, university: String, department: String, email: String, phoneNumber: String, username: String, password: String, profilePic: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.title = title
        self.university = university
        self.department = department
        self.email = email
        self.phoneNumber = phoneNumber
        self.username = username
        self.password = password
        
        // Convert the profilePic to a base64 string if an image is provided
        if let profilePic = profilePic, let imageData = profilePic.jpegData(compressionQuality: 0.8) {
            self.profilePic = imageData.base64EncodedString()
        } else {
            self.profilePic = nil
        }
    }
}

// NetworkManager to handle API requests
class NetworkManager {
    static let shared = NetworkManager() // Singleton pattern
    
    private init() {} // Private initializer to ensure a single instance
    
    // Function to create a professor by sending the data to the backend
    func createProfessor(_ professor: NewProfessor, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://localhost/API/signup.php") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(professor)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error)) // Handle encoding errors
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Handle network errors
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Parse the server's response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["Status"] as? Bool,
                   let message = json["Message"] as? String {
                    
                    if status {
                        completion(.success(message)) // Success
                    } else {
                        completion(.failure(NSError(domain: "Server error", code: -1, userInfo: [NSLocalizedDescriptionKey: message])))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume() // Start the network request
    }
}
