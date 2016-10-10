//
//  RepresentativeController.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class RepresentativeController {
	
	static let baseURLString = "http://whoismyrepresentative.com/getall_reps_bystate.php"
	
	static func searchRepsByState(_ state: String, completion: @escaping (_ representatives: [Representative]) -> Void) {
		
		guard let url = URL(string: baseURLString) else {
			completion([])
			return
		}
		
		let urlParameters = ["state": "\(state)", "output": "json"]
		
		NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
			
			if let error = error {
				NSLog("Unable to get representatives for \(state): \(error)")
				completion([])
				return
			}
			guard let data = data else {
				NSLog("Unable to get representatives for \(state): No data returned.")
				completion([])
				return
			}
			
			do {
				guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject],
					let representativeDictionaries = json["results"] as? [[String: AnyObject]] else {
						NSLog("JSON in unexpected format.")
						completion([])
						return
				}
				
				let representatives = representativeDictionaries.flatMap { Representative(json: $0) }
				
				completion(representatives)
				
			} catch {
				NSLog("Unable to deserialize JSON: \(error)")
				completion([])
				return
			}
		}
	}
}

