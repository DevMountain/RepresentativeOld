//
//  StateListTableViewController.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return States.all.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stateCell", forIndexPath: indexPath)

        let state = States.all[indexPath.row]
        
        cell.textLabel?.text = state

        return cell
    }
    
    // MARK: Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationViewController = segue.destinationViewController as? StateDetailTableViewController,
            let selectedIndex = tableView.indexPathForSelectedRow?.row {
            
            let state = States.all[selectedIndex]
            destinationViewController.state = state
        }
    }

}
