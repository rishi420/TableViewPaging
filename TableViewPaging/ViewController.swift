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
    //let totalItems = 100 // server does not provide totalItems
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
        
        //let endIndex = min(totalItems, fromIndex + batchSize)
        
//        for i in fromIndex ..< endIndex {
//            privateList.append(String(i))
//        }
        
        //print("Loading items form \(fromIndex) to \(endIndex - 1)")
        
        //fromIndex = endIndex
        //aTableView.reloadData()
        
        
        loadItemsNow("privateList")
    }
    
    func loadItemsNow(listType:String){
        //myActivityIndicator.startAnimating()
        
        let listUrlString = "http://infavori.com/json2.php?batchSize=" + String(fromIndex + batchSize) + "&fromIndex=" + String(fromIndex) + "&listType=" + listType
        let myUrl = NSURL(string: listUrlString);
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                dispatch_async(dispatch_get_main_queue(),{
                    //self.myActivityIndicator.stopAnimating()
                })
                
                return
            }
            
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray
                
                if let parseJSON = json {
                    //self.privateList = parseJSON as! [String]

                    var items = self.privateList
                    items.appendContentsOf(parseJSON as! [String])
                    
                    if self.fromIndex < items.count {
                        
                        self.privateList = items
                        self.fromIndex = items.count
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.myActivityIndicator.stopAnimating()
                            //self.myTableView.reloadData()
                            self.aTableView.reloadData()
                        })
                    }
                }
                
            } catch {
                print(error)
                
            }
        }
        
        task.resume()
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
            //if totalItems > privateList.count { //removing totalItems for always service call
                loadMoreItems()
            //}
        }
        
        return cell
    }
}
