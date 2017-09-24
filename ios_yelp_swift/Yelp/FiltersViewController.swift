//
//  FiltersViewController.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DealCellDelegate, DistanceCellDelegate, SortByCellDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var deals: [String: Bool]!
    var dealsKeys: [String]!
    var dealsValues: [Bool]!
    
    var distances: [String: Int]!
    var distancesKeys: [String]!
    var distancesValues: [Int]!
    
    var sortBys: [String: Int]!
    var sortBysKeys: [String]!
    var sortBysValues: [Int]!
    
    var categories: [[String: String]]!
    
    var dealSwitchStates = Bool()  // ???
    var categorySwitchStates = [Int:Bool]()

    // for saving currently seletcted distance index path
    var selectedDistanceIndexPath = IndexPath(row: 0, section: 1)
    var selectedSortByIndexPath = IndexPath(row: 0, section: 2)
    
    var isDistanceCellTapped = false
    var isSortByCellTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deals = yelpDeal()
        dealsKeys = Array(self.deals.keys)
        dealsValues = Array(self.deals.values)
        
        distances = yelpDistance()
        distancesKeys = Array(self.distances.keys)
        distancesValues = Array(self.distances.values)
        
        sortBys = yelpSortBy()
        sortBysKeys = Array(self.sortBys.keys)
        sortBysValues = Array(self.sortBys.values)
        
        categories = yelpCategories()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        //let defaults = UserDefaults.standard
    }
    
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        var filters = [String: AnyObject]() // save all selected filter values
    
        //var selectedDeals = [String]()
        var selectedCategories = [String]()
        
        //print("dealSwitchStates: \(dealSwitchStates)")
        // deals
        filters["deals"] = dealSwitchStates as AnyObject
        
        // distance
        filters["distance"] = distancesValues[selectedDistanceIndexPath.row] as AnyObject
        
        // sortby
        filters["sortBy"] = sortBysValues[selectedSortByIndexPath.row] as AnyObject
        
        // categories
        for (row, isSelected) in categorySwitchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        //print("filters: \(filters)")
        
        delegate?.filtersViewController? (filtersViewController: self, didUpdateFilters: filters)
        
        isDistanceCellTapped = false
        dismiss(animated: true, completion: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return deals.count
        case 1:
            if isDistanceCellTapped == true { // return 1 selected row
                return distances.count
            } else { // return all rows for the section
                return 1
            }
        case 2:
            if isSortByCellTapped == true { // return 1 selected row
                return sortBys.count
            } else { // return all rows for the section
                return 1
            }
            
        case 3:
            return categories.count
        default:
            return 0
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0: return nil
        case 1: return "Distance"
        case 2: return "Sort By"
        case 3: return "Category"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // get rid of gray selection
        
        switch (indexPath.section) {
        case 1: // distance

            if isDistanceCellTapped == false {
                isDistanceCellTapped = true
                tableView.reloadData()
                //print("isDistanceCellTapped in didSelectRowAt: \(isDistanceCellTapped)")
                break
            }
            
            if indexPath == selectedDistanceIndexPath {
                return
            }
            
            // toggle old one off and the new one on
            let newCell = tableView.cellForRow(at: indexPath)
            if newCell?.accessoryType == UITableViewCellAccessoryType.none {
                newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            let oldCell = tableView.cellForRow(at: selectedDistanceIndexPath)
            if oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                oldCell?.accessoryType = UITableViewCellAccessoryType.none
            }
            
            selectedDistanceIndexPath = indexPath  // save the selected index path
            
        
        case 2: // sort by
            
            if isSortByCellTapped == false {
                isSortByCellTapped = true
                tableView.reloadData()
                
                break
            }
            
            if indexPath == selectedSortByIndexPath {
                return
            }
            
            // toggle old one off and the new one on
            let newCell = tableView.cellForRow(at: indexPath)
            if newCell?.accessoryType == UITableViewCellAccessoryType.none {
                newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            let oldCell = tableView.cellForRow(at: selectedSortByIndexPath)
            if oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                oldCell?.accessoryType = UITableViewCellAccessoryType.none
            }
            
            selectedSortByIndexPath = indexPath  // save the selected index path
            
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case 0: // deal
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell", for: indexPath) as! DealCell
            cell.dealLabel.text = dealsKeys[indexPath.row]
            cell.delegate = self as DealCellDelegate
            dealSwitchStates = dealsValues[indexPath.row]
            cell.onDealSwitch.isOn = dealSwitchStates
            
            cell.selectionStyle = .none // get rid of gray selection
            return cell
        
        case 1: // distance
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            
            cell.distanceLabel.text = distancesKeys[indexPath.row]
            
            cell.delegate = self as DistanceCellDelegate
            
            tableView.cellForRow(at: selectedDistanceIndexPath)?.accessoryType = .checkmark
            
            if indexPath == selectedDistanceIndexPath {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            
            
            cell.selectionStyle = .none // get rid of gray selection
            return cell
        
        case 2: // sort by
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell", for: indexPath) as! SortByCell
            cell.sortByLabel.text = sortBysKeys[indexPath.row]
            
            cell.delegate = self as SortByCellDelegate
            
            tableView.cellForRow(at: selectedSortByIndexPath)?.accessoryType = .checkmark
            
            if indexPath == selectedSortByIndexPath {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            
            cell.selectionStyle = .none // get rid of gray selection
            return cell
        
        case 3: // category
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self as SwitchCellDelegate
            
            cell.onOffSwitch.isOn = categorySwitchStates[(indexPath.row)] ?? false
            cell.selectionStyle = .none // get rid of gray selection
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self as SwitchCellDelegate
            
            cell.onOffSwitch.isOn = categorySwitchStates[(indexPath.row)] ?? false

            return cell
            
            
        }
    }
    
    
    
    func dealCell(DealCell: DealCell, didChangeValue value: Bool) {
        //let indexPath = tableView.indexPath(for: DealCell)
        
        dealSwitchStates = value
        print ("deal switch event in filter view")
    }
    
    func switchCell(SwitchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: SwitchCell)
        
        categorySwitchStates[(indexPath?.row)!] = value
        print ("category switch event in filter view")
    }
 
    
    func yelpDeal() -> [String:Bool] {
        return
            ["Offering a Deal": false]
    }
    
    func yelpDistance() -> [String:Int] {
        return [
            "0.3 mile": 480,
            "1 mile": 1600,
            "5 miles": 8000,
            "20 miles": 32000
        ]
    }
    
    func yelpSortBy() -> [String:Int] {
        return [
            "Best Match": 0,
            "Distance": 1,
            "Highest Rated": 2
        ]
    }
    
    func yelpCategories() -> [[String:String]] {
        return [
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American, New", "code": "newamerican"],
            ["name": "American, Traditional", "code": "tradamerican"],
            ["name": "Arabian", "code": "arabian"],
            ["name": "Argentine", "code": "argentine"],
            ["name": "Armenian", "code": "armenian"],
            ["name": "Asian Fusion", "code": "asianfusion"],
            ["name": "Asturian", "code": "asturian"],
            ["name": "Australian", "code": "australian"],
            ["name": "Austrian", "code": "austrian"],
            ["name": "Baguettes", "code": "baguettes"],
            ["name": "Bangladeshi", "code": "bangladeshi"],
            ["name": "Barbeque", "code": "bbq"],
            ["name": "Basque", "code": "basque"],
            ["name": "Bavarian", "code": "bavarian"],
            ["name": "Beer Garden", "code": "beergarden"],
            ["name": "Beer Hall", "code": "beerhall"],
            ["name": "Beisl", "code": "beisl"],
            ["name": "Belgian", "code": "belgian"],
            ["name": "Bistros", "code": "bistros"],
            ["name": "Black Sea", "code": "blacksea"],
            ["name": "Brasseries", "code": "brasseries"],
            ["name": "Brazilian", "code": "brazilian"],
            ["name": "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name": "British", "code": "british"],
            ["name": "Buffets", "code": "buffets"],
            ["name": "Bulgarian", "code": "bulgarian"],
            ["name": "Burgers", "code": "burgers"],
            ["name": "Burmese", "code": "burmese"],
            ["name": "Cafes", "code": "cafes"],
            ["name": "Cafeteria", "code": "cafeteria"],
            ["name": "Cajun/Creole", "code": "cajun"],
            ["name": "Cambodian", "code": "cambodian"],
            ["name": "Canadian", "code": "New)"],
            ["name": "Canteen", "code": "canteen"],
            ["name": "Caribbean", "code": "caribbean"],
            ["name": "Catalan", "code": "catalan"],
            ["name": "Chech", "code": "chech"],
            ["name": "Cheesesteaks", "code": "cheesesteaks"],
            ["name": "Chicken Shop", "code": "chickenshop"],
            ["name": "Chicken Wings", "code": "chicken_wings"],
            ["name": "Chilean", "code": "chilean"],
            ["name": "Chinese", "code": "chinese"],
            ["name": "Comfort Food", "code": "comfortfood"],
            ["name": "Corsican", "code": "corsican"],
            ["name": "Creperies", "code": "creperies"],
            ["name": "Cuban", "code": "cuban"],
            ["name": "Curry Sausage", "code": "currysausage"],
            ["name": "Cypriot", "code": "cypriot"],
            ["name": "Czech", "code": "czech"],
            ["name": "Czech/Slovakian", "code": "czechslovakian"],
            ["name": "Danish", "code": "danish"],
            ["name": "Delis", "code": "delis"],
            ["name": "Diners", "code": "diners"],
            ["name": "Dumplings", "code": "dumplings"],
            ["name": "Eastern European", "code": "eastern_european"],
            ["name": "Ethiopian", "code": "ethiopian"],
            ["name": "Fast Food", "code": "hotdogs"],
            ["name": "Filipino", "code": "filipino"],
            ["name": "Fish & Chips", "code": "fishnchips"],
            ["name": "Fondue", "code": "fondue"],
            ["name": "Food Court", "code": "food_court"],
            ["name": "Food Stands", "code": "foodstands"],
            ["name": "French", "code": "french"],
            ["name": "French Southwest", "code": "sud_ouest"],
            ["name": "Galician", "code": "galician"],
            ["name": "Gastropubs", "code": "gastropubs"],
            ["name": "Georgian", "code": "georgian"],
            ["name": "German", "code": "german"],
            ["name": "Giblets", "code": "giblets"],
            ["name": "Gluten-Free", "code": "gluten_free"],
            ["name": "Greek", "code": "greek"],
            ["name": "Halal", "code": "halal"],
            ["name": "Hawaiian", "code": "hawaiian"],
            ["name": "Heuriger", "code": "heuriger"],
            ["name": "Himalayan/Nepalese", "code": "himalayan"],
            ["name": "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name": "Hot Dogs", "code": "hotdog"],
            ["name": "Hot Pot", "code": "hotpot"],
            ["name": "Hungarian", "code": "hungarian"],
            ["name": "Iberian", "code": "iberian"],
            ["name": "Indian", "code": "indpak"],
            ["name": "Indonesian", "code": "indonesian"],
            ["name": "International", "code": "international"],
            ["name": "Irish", "code": "irish"],
            ["name": "Island Pub", "code": "island_pub"],
            ["name": "Israeli", "code": "israeli"],
            ["name": "Italian", "code": "italian"],
            ["name": "Japanese", "code": "japanese"],
            ["name": "Jewish", "code": "jewish"],
            ["name": "Kebab", "code": "kebab"],
            ["name": "Korean", "code": "korean"],
            ["name": "Kosher", "code": "kosher"],
            ["name": "Kurdish", "code": "kurdish"],
            ["name": "Laos", "code": "laos"],
            ["name": "Laotian", "code": "laotian"],
            ["name": "Latin American", "code": "latin"],
            ["name": "Live/Raw Food", "code": "raw_food"],
            ["name": "Lyonnais", "code": "lyonnais"],
            ["name": "Malaysian", "code": "malaysian"],
            ["name": "Meatballs", "code": "meatballs"],
            ["name": "Mediterranean", "code": "mediterranean"],
            ["name": "Mexican", "code": "mexican"],
            ["name": "Middle Eastern", "code": "mideastern"],
            ["name": "Milk Bars", "code": "milkbars"],
            ["name": "Modern Australian", "code": "modern_australian"],
            ["name": "Modern European", "code": "modern_european"],
            ["name": "Mongolian", "code": "mongolian"],
            ["name": "Moroccan", "code": "moroccan"],
            ["name": "New Zealand", "code": "newzealand"],
            ["name": "Night Food", "code": "nightfood"],
            ["name": "Norcinerie", "code": "norcinerie"],
            ["name": "Open Sandwiches", "code": "opensandwiches"],
            ["name": "Oriental", "code": "oriental"],
            ["name": "Pakistani", "code": "pakistani"],
            ["name": "Parent Cafes", "code": "eltern_cafes"],
            ["name": "Parma", "code": "parma"],
            ["name": "Persian/Iranian", "code": "persian"],
            ["name": "Peruvian", "code": "peruvian"],
            ["name": "Pita", "code": "pita"],
            ["name": "Pizza", "code": "pizza"],
            ["name": "Polish", "code": "polish"],
            ["name": "Portuguese", "code": "portuguese"],
            ["name": "Potatoes", "code": "potatoes"],
            ["name": "Poutineries", "code": "poutineries"],
            ["name": "Pub Food", "code": "pubfood"],
            ["name": "Rice", "code": "riceshop"],
            ["name": "Romanian", "code": "romanian"],
            ["name": "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name": "Rumanian", "code": "rumanian"],
            ["name": "Russian", "code": "russian"],
            ["name": "Salad", "code": "salad"],
            ["name": "Sandwiches", "code": "sandwiches"],
            ["name": "Scandinavian", "code": "scandinavian"],
            ["name": "Scottish", "code": "scottish"],
            ["name": "Seafood", "code": "seafood"],
            ["name": "Serbo Croatian", "code": "serbocroatian"],
            ["name": "Signature Cuisine", "code": "signature_cuisine"],
            ["name": "Singaporean", "code": "singaporean"],
            ["name": "Slovakian", "code": "slovakian"],
            ["name": "Soul Food", "code": "soulfood"],
            ["name": "Soup", "code": "soup"],
            ["name": "Southern", "code": "southern"],
            ["name": "Spanish", "code": "spanish"],
            ["name": "Steakhouses", "code": "steak"],
            ["name": "Sushi Bars", "code": "sushi"],
            ["name": "Swabian", "code": "swabian"],
            ["name": "Swedish", "code": "swedish"],
            ["name": "Swiss Food", "code": "swissfood"],
            ["name": "Tabernas", "code": "tabernas"],
            ["name": "Taiwanese", "code": "taiwanese"],
            ["name": "Tapas Bars", "code": "tapas"],
            ["name": "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name": "Tex-Mex", "code": "tex-mex"],
            ["name": "Thai", "code": "thai"],
            ["name": "Traditional Norwegian", "code": "norwegian"],
            ["name": "Traditional Swedish", "code": "traditional_swedish"],
            ["name": "Trattorie", "code": "trattorie"],
            ["name": "Turkish", "code": "turkish"],
            ["name": "Ukrainian", "code": "ukrainian"],
            ["name": "Uzbek", "code": "uzbek"],
            ["name": "Vegan", "code": "vegan"],
            ["name": "Vegetarian", "code": "vegetarian"],
            ["name": "Venison", "code": "venison"],
            ["name": "Vietnamese", "code": "vietnamese"],
            ["name": "Wok", "code": "wok"],
            ["name": "Wraps", "code": "wraps"],
            ["name": "Yugoslav", "code": "yugoslav"]
        ]
    }

}

