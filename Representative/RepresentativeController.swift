//
//  RepresentativeController.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class RepresentativeController {
	
	static let baseURL = URL(string: "http://whoismyrepresentative.com/getall_reps_bystate.php")!
	
	static let shared = RepresentativeController()
	
    func searchRepresentatives(forState state: String, completion: @escaping (_ representatives: [Representative]) -> Void) {
        
        let url = RepresentativeController.baseURL
        let urlParameters = ["state": "\(state)", "output": "json"]
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let queryItems = urlParameters.flatMap({ URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = queryItems
        
        guard let requestURL = components?.url else { completion([]); return }

        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Unable to get representatives for \(state): \(error)")
                completion([])
                return
            }
            guard let data = data, let responseDataString = String(data: data, encoding: .utf8) else {
                NSLog("Unable to get representatives for \(state): No data returned.")
                completion([])
                return
            }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let representativeDictionaries = jsonDictionary["results"] as? [[String: Any]] else {
                    NSLog("Unable to serialize json. \nResponse: \(responseDataString)")
                        completion([])
                        return
                }
                
                let representatives = representativeDictionaries.flatMap { Representative(json: $0) }
                completion(representatives)
        }
        
        dataTask.resume()
    }
}

