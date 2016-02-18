//
//  ViewController.swift
//  TableViewPaging
//
//  Created by Warif Akhand Rishi on 2/19/16.
//  Copyright © 2016 Warif Akhand Rishi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var aTableView: UITableView!
    
    var privateList = [String]()
    let totalItems = 100
    var fromIndex = 0
    let batchSize = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        privateList.removeAll()
        loadMoreItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadMoreItems() {
        
        let endIndex = min(totalItems, fromIndex + batchSize)
        
        for i in fromIndex ..< endIndex {
            privateList.append(String(i))
        }
        
        print("Loading items form \(fromIndex) to \(endIndex - 1)")
        
        fromIndex = endIndex
        aTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = privateList[indexPath.row]
        
        if indexPath.row == privateList.count - 1 { // last cell
            if totalItems > privateList.count {
                loadMoreItems()
            }
        }
        
        return cell
    }
}
