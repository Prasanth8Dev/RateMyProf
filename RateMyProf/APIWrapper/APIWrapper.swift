//
//  APIWrapper.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import Combine
import UIKit

enum APIError: Error {
    case invalidResponse
    case requestFailed
    case decodingError
}

class APIWrapper {
    static let shared = APIWrapper()
    
    func postRequestMethod<T: Decodable>(url: URL, body: [String: Any], responseType: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert body to JSON data
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                // Print the raw response data as a string
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                } else {
                    print("Unable to convert data to string")
                }
                
                // Return the data to be decoded
                return output.data
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                print("Error in request: \(error)")
                // Re-throw the error
                throw error
            }
            .tryMap { data -> T in
                do {
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    return decodedResponse
                } catch {
                    print("Decoding failed with error: \(error)")
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                    throw APIError.decodingError
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func postMultipartFormData<T: Decodable>(url: URL, parameters: [String: Any], responseType: T.Type) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let timestamp = DateFormatter().timestampString()
        // Add parameters to body
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            if let stringValue = value as? String {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(stringValue)\r\n".data(using: .utf8)!)
            } else if let image = value as? UIImage, let imageData = image.jpegData(compressionQuality: 1.0) {
                // Assuming image is passed as UIImage
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(timestamp).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        // Close the body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                // Print the raw response data as a string
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                } else {
                    print("Unable to convert data to string")
                }
                
                // Return the data to be decoded
                return output.data
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                print("Error in request: \(error)")
                throw error
            }
            .tryMap { data -> T in
                do {
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    return decodedResponse
                } catch {
                    print("Decoding failed with error: \(error)")
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                    throw APIError.decodingError
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getRequestMethod<T: Decodable>(url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                // Print the raw response data as a string
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                } else {
                    print("Unable to convert data to string")
                }
                
                // Return the data to be decoded
                return output.data
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                print("Error in request: \(error)")
                // Re-throw the error
                throw error
            }
            .tryMap { data -> T in
                do {
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    return decodedResponse
                } catch {
                    print("Decoding failed with error: \(error)")
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                    throw APIError.decodingError
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    
    
    
}

extension DateFormatter {
    func timestampString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss" // Example format: 20241023123045
        return formatter.string(from: Date())
    }
}
//return URLSession.shared.dataTaskPublisher(for: request)
//    .tryMap { output in
//        guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw APIError.invalidResponse
//        }
//        return output.data
//    }
//    .decode(type: T.self, decoder: JSONDecoder())
//    .receive(on: RunLoop.main)
//    .eraseToAnyPublisher()
