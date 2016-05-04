//
//  Representative.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Representative {
    
    private let NameKey = "name"
    private let PartyKey = "party"
    private let StateKey = "state"
    private let DistrictKey = "district"
    private let PhoneKey = "phone"
    private let OfficeKey = "office"
    private let LinkKey = "link"
    
    let name: String
    let party: String
    let state: String
    let district: String
    let phone: String
    let office: String
    let link: String
    
    init?(json: [String: AnyObject]) {
        
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
}