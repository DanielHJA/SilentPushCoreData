//
//  Webservice.swift
//  SilentPushTest
//
//  Created by Daniel Hjärtström on 2019-11-27.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import UIKit

class Webservice<T: Decodable>: NSObject {

    class func fetch(urlString: String, completion: @escaping (Result<[[String: Any]], Error>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String: Any]] {
                    completion(.success(json))
                }
            }
            
//            if let data: T = data?.decode() {
//                    completion(.success(data))
//            }
            
        }.resume()
    }
    
}
