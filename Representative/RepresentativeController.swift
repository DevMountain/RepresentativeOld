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
	
	static func searchRepsByState(state: String, completion: (representatives: [Representative]) -> Void) {
		
		guard let url = NSURL(string: baseURLString) else {
			completion(representatives: [])
			return
		}
		
		let urlParameters = ["state": "\(state)", "output": "json"]
		
		NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
			
			if let error = error {
				NSLog("Unable to get representatives for \(state): \(error)")
				completion(representatives: [])
				return
			}
			guard let data = data else {
				NSLog("Unable to get representatives for \(state): No data returned.")
				completion(representatives: [])
				return
			}
			
			do {
				guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
					let representativeDictionaries = json["results"] as? [[String: AnyObject]] else {
						NSLog("JSON in unexpected format.")
						completion(representatives: [])
						return
				}
				
				let representatives = representativeDictionaries.flatMap { Representative(json: $0) }
				
				completion(representatives: representatives)
				
			} catch {
				NSLog("Unable to deserialize JSON: \(error)")
				completion(representatives: [])
				return
			}
		}
	}
}

