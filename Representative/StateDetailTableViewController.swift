//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        if let state = state {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            RepresentativeController.searchRepsByState(state, completion: { (representatives) in
                
                self.representatives = representatives
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            })
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return representatives.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("representativeCell", forIndexPath: indexPath) as? RepresentativeTableViewCell ?? RepresentativeTableViewCell()
        
        cell.representative = representatives[indexPath.row]
		
        return cell
    }
	
	// MARK: Properties
	
	var state: String?
	var representatives: [Representative] = []
}
