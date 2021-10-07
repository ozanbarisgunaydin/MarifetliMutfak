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
import Accelerate

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
        tableView.allowsMultipleSelectionDuringEditing = true
        
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
            cell.dinnerCategoryLabel.text = filteredDinners[indexPath.section].dinnerCategory
            cell.dinnerNameLabel.text = filteredDinners[indexPath.section].dinnerTitle[indexPath.row]
            cell.dinnerImageLabel.kf.setImage(with: URL(string: filteredDinners[indexPath.section].imageUrlArray[indexPath.row]))
        } else {
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
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            print(indexPath.row)
            
            fireStoreDatabase.collection("Recipes").whereField("dinnerCategory", isEqualTo: dinnersArray[indexPath.section].dinnerCategory).getDocuments { snapshot, error in
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error")
                } else {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        
                        for document in snapshot!.documents {
                            
                            let documentId = document.documentID
                            print(documentId)
                            
                            if editingStyle == .delete{
                                
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["dinnerTitle" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerTitle[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["dinnerDescription" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].description[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["imageUrlArray" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].imageUrlArray[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["Int1" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerInt1[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["Int2" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerInt2[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["Int3" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerInt3[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["Int4" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerInt4[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["unit1" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerUnit1[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["unit2" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerUnit2[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["unit3" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerUnit3[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["unit4" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerUnit4[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["material1" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerMaterial1[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["material2" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerMaterial2[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["material3" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerMaterial3[indexPath.row]])])
                                self.fireStoreDatabase.collection("Recipes").document(documentId).updateData(["material4" : FieldValue.arrayRemove([self.dinnersArray[indexPath.section].dinnerMaterial4[indexPath.row]])])
                            }
                        }
                    }
                }
            }
    }
}

extension FeedVC: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        filteredDinners.removeAll()
        filteredDinners = dinnersArray
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
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
                
            } else {
                
                searchActive = true
                filteredDinners = dinnersArray.filter({ title -> Bool in
                    return title.dinnerTitle[0].lowercased().contains(searchText.lowercased())
                })
            }
        self.tableView.reloadData()
    }

}
