//
//  LocationsViewController.swift
//  Photo Map
//
//  Created by Timothy Lee on 10/20/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

protocol LocationsViewControllerDelegate: class {
    func locationsViewController(locationsViewController: LocationsViewController, didSelectLocation location: PhotoMapAnnotation)
}

class LocationsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    weak var delegate: LocationsViewControllerDelegate?
    
    var results: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LocationsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as LocationCell
        
        cell.location = results[indexPath.row] as NSDictionary
        
        return cell
    }
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // This is the selected venue
        var venue = results[indexPath.row] as NSDictionary
        
        var lat = venue.valueForKeyPath("location.lat") as Double
        var lng = venue.valueForKeyPath("location.lng") as Double
        
        var latString = "\(lat)"
        var lngString = "\(lng)"
        
        println(latString + " " + lngString)

        delegate?.locationsViewController(self, didSelectLocation: PhotoMapAnnotation(latitude: lat, longitude: lng))
    }
}

extension LocationsViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newText = NSString(string: searchBar.text).stringByReplacingCharactersInRange(range, withString: text)
        fetchLocations(newText)
        
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fetchLocations(searchBar.text)
    }
    
    func fetchLocations(query: String, near: String = "Sunnyvale") {
        var url = "https://api.foursquare.com/v2/venues/search?client_id=QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL&client_secret=W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU&v=20141020&near=\(near),CA&query=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
        var request = NSURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (data != nil) {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.results = responseDictionary.valueForKeyPath("response.venues") as NSArray
                self.tableView.reloadData()
            }
        }
    }

}