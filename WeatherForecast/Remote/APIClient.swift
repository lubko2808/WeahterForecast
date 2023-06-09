//
//  APIClient.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 08.06.2023.
//

import Foundation

extension API {
    
    class Client {
        static let shared = Client()
        private let decoder = JSONDecoder()
        
        
        func fetch<Response: Decodable>(_ endpoint: Types.Endpoint, completion: ((Result<Response, Types.Error>) -> Void)? = nil) {
            
            let urlRequest = URLRequest(url: endpoint.url)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Fetch error: \(error)")
                    completion?(.failure(.generic(reason: "Could not fetch data: \(error.localizedDescription)")))
                    return
                } else {
                    if let data = data {
                        do {
                            let result = try self.decoder.decode(Response.self, from: data)
                            completion?(.success(result))
                        } catch {
                            print("Decoding error: \(error)")
                            completion?(.failure(.generic(reason: "Could not decode data: \(error.localizedDescription)")))
                        }
                    }
                    
                }
            }
            dataTask.resume()
        }
    }
}
