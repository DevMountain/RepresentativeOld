//
//  Representative.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Representative {
    
    fileprivate let NameKey = "name"
    fileprivate let PartyKey = "party"
    fileprivate let StateKey = "state"
    fileprivate let DistrictKey = "district"
    fileprivate let PhoneKey = "phone"
    fileprivate let OfficeKey = "office"
    fileprivate let LinkKey = "link"
    
    init?(json: [String: Any]) {
        
        guard let name = json[NameKey] as? String,
            let party = json[PartyKey] as? String,
            let state = json[StateKey] as? String,
            let district = json[DistrictKey] as? String,
            let phone = json[PhoneKey] as? String,
            let office = json[OfficeKey] as? String,
            let link = json[LinkKey] as? String else { return nil }
        
        self.name = name
        self.party = party
        self.state = state
        self.district = district
        self.phone = phone
        self.office = office
        self.link = link
    }
	
	// MARK: Properties
	
	let name: String
	let party: String
	let state: String
	let district: String
	let phone: String
	let office: String
	let link: String
}
