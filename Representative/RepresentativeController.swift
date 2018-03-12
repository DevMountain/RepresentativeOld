//
//  RepresentativeController.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class RepresentativeController {
	
	static let baseURL = URL(string: "https://whoismyrepresentative.com/getall_reps_bystate.php")!
	
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
			
			/*
			whoismyrepresentative.com incorrectly encodes letters with diacrtic marks, e.g. ú using
			extended ASCII, not UTF-8. This means that trying to convert the data to a string using .utf8 will
			fail for some states, where the representatives have diacritics in their names.
			
			To workaround this, we decode into a string using ASCII, then reencode the string as data using .utf8
			before passing the fixed UTF-8 data into the JSON decoder.
			*/
			
			guard let data = data,
				let responseDataString = String(data: data, encoding: .ascii),
				let fixedData = responseDataString.data(using: .utf8) else { // Convert string back to UTF8 data
					NSLog("Unable to get representatives for \(state): No data returned.")
					completion([])
					return
			}
			
			guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: fixedData, options: [])) as? [String: Any],
				let representativeDictionaries = jsonDictionary["results"] as? [[String: Any]] else {
					NSLog("Unable to deserialize json. \nResponse: \(responseDataString)")
					completion([])
					return
			}
			
			let representatives = representativeDictionaries.flatMap { Representative(json: $0) }
			completion(representatives)
		}
		
		dataTask.resume()
	}
}

