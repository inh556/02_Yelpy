//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    
    var filteredBusinesses: [Business]!
    
    var searchBar: UISearchBar!
    
    var savedFilters = [String: AnyObject]()
    
    var isMoreDataLoading = false // Inifinite scroll
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Restaurant"
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Infinite scroll - start
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Infinite scroll - end
        
        //print("default savedFilters upon init: \(savedFilters)")
        
        
        if savedFilters["deals"] == nil {
            savedFilters["deals"] = false as AnyObject
        }
        
        if savedFilters["distance"] == nil {
            savedFilters["distance"] = 8000 as AnyObject
        }
        
        if savedFilters["sortBy"] == nil {
            savedFilters["sortBy"] = 0 as AnyObject
        }
        
        if savedFilters["categories"] == nil {
            savedFilters["categories"] = [] as AnyObject
        }
        
        
        Business.searchWithTerm(term: "Restaurants", sort: YelpSortMode(rawValue: savedFilters["sortBy"] as! Int), categories: savedFilters["categories"] as? [String], distance: savedFilters["distance"] as? Int, deals: savedFilters["deals"] as? Bool) { (businesses: [Business]!, error: Error!) -> Void in
            
            self.businesses = businesses
         
            self.filteredBusinesses = self.businesses

            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return filteredBusinesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        //cell.business = businesses[indexPath.row]
        
        cell.selectionStyle = .none // get rid of gray selection
        
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBusinesses = searchText.isEmpty ? self.businesses : self.businesses!.filter { (item: Business) -> Bool in
            // If dataItem matches the searchText, return true to include it
            //print("searchText: \(searchText)")
            let bizName = item.name
            //print("biz name match: \(String(describing: bizName?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)))")
            return bizName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    //search bar functionality related - end
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterViewControllerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController

            filtersViewController.delegate = self
        }
        else if segue.identifier == "mapViewControllerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let mapViewController = navigationController.topViewController as! MapViewController
            
            mapViewController.businesses = businesses

        }
        else if segue.identifier == "detailsViewControllerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let detailsViewController = navigationController.topViewController as! DetailsViewController
            
            let tableCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: tableCell)
            let business = businesses![indexPath!.row]
            
            detailsViewController.business = business
            
            tableCell.selectionStyle = .none
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let savedFilters = filters
        //print("savedFilters: \(savedFilters)")
        
        let deals = filters["deals"] as? Bool
        let distance = filters["distance"] as? Int
        let sortBy = YelpSortMode(rawValue: filters["sortBy"] as! Int)
        let categories = filters["categories"] as? [String]
            
        Business.searchWithTerm(term: "Restaurants", sort: sortBy, categories: categories, distance: distance, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
            
                self.filteredBusinesses = self.businesses
                self.tableView.reloadData()
                //print("table view reloaded")
            }
    )}
    
    // Inifite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                
                    Business.searchWithTerm(term: "Restaurants", sort: YelpSortMode(rawValue: savedFilters["sortBy"] as! Int), categories: savedFilters["categories"] as? [String], distance: savedFilters["distance"] as? Int, deals: savedFilters["deals"] as? Bool) { (businesses: [Business]!, error: Error!) -> Void in
                        
                        self.isMoreDataLoading = false
                        
                        if self.businesses != nil {
                            
                            for business in businesses {
                                self.businesses.append(business)
                            }
                        }
                        
                        //self.businesses = businesses
                        
                        self.filteredBusinesses = self.businesses
                        
                        self.tableView.reloadData()

                }

            }
        }
    }

}


class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}
