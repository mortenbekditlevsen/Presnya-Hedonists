//
//  FeedVC.swift
//  PresnyaHedonist
//
//  Created by Alexandr L. on 7/13/21.
//

import UIKit

class FeedVC: UIViewController {
    
    var places = [Place]()
    var filteredPlaces = [Place]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableViewFeed: UITableView!
    
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        let searchScopeFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty || searchScopeFiltering)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFeed.delegate = self
        tableViewFeed.dataSource = self
        tableViewFeed.tableSeparator()
        
        configureController()
        configureSearchController()
        
        fetchData()
    }
    
    
    func configureController() {
        navigationController?.navigationBar.prefersLargeTitles  = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Fonts.vcHeads!]
        title = VCTitles.feedTitle
    }
    
    
    func fetchData() {
        do {
            places = try context.fetch(Place.fetchRequest())
            
        } catch {
            presentAlert(title: AlertTitle.error,
                         message: Errors.fetchError)
        }
    }
    
    
    func configureSearchController() {
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.obscuresBackgroundDuringPresentation   = false
        searchController.searchBar.placeholder                  = "Поиск..."
        searchController.searchBar.scopeButtonTitles            = ["Все", "Ресторан", "Места", "Завтраки", "Бар"]
        
        navigationItem.searchController                         = searchController
        definesPresentationContext                              = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tableViewFeed.indexPathForSelectedRow == nil {
            return
        }
        
        if let indexPath = tableViewFeed.indexPathForSelectedRow {
            
            var place: Place
            
            if isFiltering { place = filteredPlaces[indexPath.row] }
            else { place = places[indexPath.row] }
            
            let destination = segue.destination as! DetailsVC
            destination.place = place
        }
    }
}


extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return filteredPlaces.count }
        return places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsID.FEED_CELL) as! FeedCell
        
        var place: Place
        
        if isFiltering { place = filteredPlaces[indexPath.row] }
        else { place = places[indexPath.row] }
        
        cell.setCell(place)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewFeed.deselectRow(at: indexPath, animated: true)
    }
}


extension FeedVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        contentFilter(searchController.searchBar.text!, scope: scope)
    }
    
    
    func contentFilter(_ searchText: String, scope: String = "Все") {
        
        filteredPlaces = places.filter({ (place) -> Bool in
            let categoryMatch = (scope == "Все") || (place.category == scope)
            if searchBarIsEmpty { return categoryMatch }
            return categoryMatch && place.name!.lowercased().contains(searchText.lowercased()) })
    
        DispatchQueue.main.async { self.tableViewFeed.reloadData() }
    }
}


extension FeedVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        contentFilter(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
