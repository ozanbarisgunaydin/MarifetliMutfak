//
//  FeedVC.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseDatabase

class FeedVC: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    private var searchActive : Bool = false
    private let searchController = UISearchController(searchResultsController: nil)

    private let fireStoreDatabase = Firestore.firestore()
  
    private var dinnersArray = [Dinners]()
    private var filteredDinners = [Dinners]()
    private var chosenDinner : Dinners?
    private var chosenRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
  
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .sentences
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 250, height: 90)
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchBarStyle = UISearchBar.Style.default
        searchController.searchBar.placeholder = "Hadi yaz ve yemeklerini bul... :)"
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clearButtonMode = .never

        
        getRecipesFromFireBase()
    }
    
    func getRecipesFromFireBase() {
        
        fireStoreDatabase.collection("Recipes").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.dinnersArray.removeAll(keepingCapacity: false)
                    
                for document in snapshot!.documents {

                    
                    if let dinnerTitle = document.get("dinnerTitle") as? [String] {
                        if let dinnerCategory = document.get("dinnerCategory") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let dinnerInt1 = document.get("Int1") as? [String]  {
                                    if let dinnerUnit1 = document.get("unit1") as? [String]  {
                                        if let dinnerMaterial1 = document.get("material1") as? [String]  {
                                            if let description = document.get("dinnerDescription") as? [String]  {
                                                    if let dinnerMaterial2 = document.get("material2") as? [String]  {
                                                        if let dinnerInt2 = document.get("Int2") as? [String]  {
                                                            if let dinnerUnit2 = document.get("unit2") as? [String]  {
                                                                if let dinnerMaterial3 = document.get("material3") as? [String]  {
                                                                    if let dinnerInt3 = document.get("Int3") as? [String]  {
                                                                        if let dinnerUnit3 = document.get("unit3") as? [String]  {
                                                                            if let dinnerMaterial4 = document.get("material4") as? [String]  {
                                                                                if let dinnerInt4 = document.get("Int4") as? [String]  {
                                                                                    if let dinnerUnit4 = document.get("unit4") as? [String]   {
                            
                                                                                        let dinners = Dinners(dinnerTitle: dinnerTitle, dinnerCategory: dinnerCategory, imageUrlArray: imageUrlArray, description: description, dinnerMaterial1: dinnerMaterial1, dinnerUnit1: dinnerUnit1, dinnerInt1: dinnerInt1, dinnerMaterial2: dinnerMaterial2, dinnerInt2: dinnerInt2, dinnerUnit2: dinnerUnit2, dinnerMaterial3: dinnerMaterial3, dinnerInt3: dinnerInt3, dinnerUnit3: dinnerUnit3, dinnerMaterial4: dinnerMaterial4, dinnerInt4: dinnerInt4, dinnerUnit4: dinnerUnit4)
                                                   
                                                    self.dinnersArray.append(dinners)
                                                                                       
                                                                                    }
                                                                                    
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                    DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                }
            }
        }
    }

   

    
extension FeedVC: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell

        if searchActive == true {
            print("search active!")
            cell.dinnerCategoryLabel.text = filteredDinners[indexPath.section].dinnerCategory
            cell.dinnerNameLabel.text = filteredDinners[indexPath.section].dinnerTitle[indexPath.row]
            cell.dinnerImageLabel.kf.setImage(with: URL(string: filteredDinners[indexPath.section].imageUrlArray[indexPath.row]))
        } else {
            print("yenilendim 1")
            print("search deactive!")
            cell.dinnerCategoryLabel.text = dinnersArray[indexPath.section].dinnerCategory
            cell.dinnerNameLabel.text = dinnersArray[indexPath.section].dinnerTitle[indexPath.row]
            cell.dinnerImageLabel.kf.setImage(with: URL(string: dinnersArray[indexPath.section].imageUrlArray[indexPath.row]))
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive == true {
         return filteredDinners.count
        } else {
        return dinnersArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filteredDinners[section].dinnerTitle.count
        } else {
            return dinnersArray[section].dinnerTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dinnersArray[section].dinnerCategory
    }
        
}

extension FeedVC: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDinnerVC" {
            
            let destinationVC = segue.destination as! DinnerViewController
            destinationVC.selectedDinner = chosenDinner
            destinationVC.selectedRow = chosenRow
            
        }
    }
    

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchActive == false {
            chosenDinner = self.dinnersArray[indexPath.section]
            chosenRow = indexPath.row
            print(chosenRow)
        } else {
            chosenDinner = self.filteredDinners[indexPath.section]
            chosenRow = indexPath.row
            print(chosenRow)
        }
        
        performSegue(withIdentifier: "toDinnerVC", sender: nil)

    }
            
}

extension FeedVC: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
        print("text editING")
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
        print("text editED")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        filteredDinners.removeAll()
        filteredDinners = dinnersArray
        self.tableView.reloadData()
        print("cancel clicked")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        print("search clicked")
    }

    func filterContent (searchText:String) {
        
        self.filteredDinners = self.dinnersArray.filter { dinnersArray in
            
            let dinnerName = dinnersArray.dinnerTitle[0].lowercased()
            return(dinnerName.contains(searchText.lowercased()))
        }
        
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
        searchController.showsSearchResultsController = true
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty  else { dinnersArray = filteredDinners; return }
        
        filteredDinners.removeAll()
        
        let searchText = searchBar.text!.lowercased()
            if searchText.isEmpty  {
                
                searchActive = false
                
                filteredDinners.removeAll()
                filteredDinners = dinnersArray
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                print("yenilendim2")
                
            } else {
                
                searchActive = true
        
                filteredDinners = dinnersArray.filter({ title -> Bool in
                    return title.dinnerTitle[0].lowercased().contains(searchText.lowercased())
                })
            }
        self.tableView.reloadData()
    }

}
