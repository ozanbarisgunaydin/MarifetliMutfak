//
//  FeedVC.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    
    var dinnersArray = [Dinners]()
    var chosenDinner : Dinners?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getRecipesFromFireBase()
//        getUserInfo()
  
       
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
                        if let dinnerCategory = document.get("dinnercategoryArray") as? [String] {
                            if let imageUrl = document.get("imageUrl") as? String {
                                if let dinnerInt1 = document.get("Int1") as? String {
                                if let date = document.get("date") as? Timestamp {
                                    if let dinnerUnit1 = document.get("unit1") as? String {
                                        if let dinnerMaterial1 = document.get("material1") as? String {
                                            if let description = document.get("dinnerDescription") as? String {
                                                    if let dinnerMaterial2 = document.get("material2") as? String {
                                                        if let dinnerInt2 = document.get("Int2") as? String {
                                                            if let dinnerUnit2 = document.get("unit2") as? String {
                                                                if let dinnerMaterial3 = document.get("material3") as? String {
                                                                    if let dinnerInt3 = document.get("Int3") as? String {
                                                                        if let dinnerUnit3 = document.get("unit3") as? String {
                                                                            if let dinnerMaterial4 = document.get("material4") as? String {
                                                                                if let dinnerInt4 = document.get("Int4") as? String {
                                                                                    if let dinnerUnit4 = document.get("unit4") as? String {
                            

                                            
                                                                                        let dinners = Dinners(dinnerTitle: dinnerTitle, dinnerCategoryArray: dinnerCategory, imageUrl: imageUrl, description: description, dinnerMaterial1: dinnerMaterial1, dinnerUnit1: dinnerUnit1, dinnerInt1: dinnerInt1, date: date.dateValue(), dinnerMaterial2: dinnerMaterial2, dinnerInt2: dinnerInt2, dinnerUnit2: dinnerUnit2, dinnerMaterial3: dinnerMaterial3, dinnerInt3: dinnerInt3, dinnerUnit3: dinnerUnit3, dinnerMaterial4: dinnerMaterial4, dinnerInt4: dinnerInt4, dinnerUnit4: dinnerUnit4)
                                                   
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
                                                    
                                       
                                            
                            
          
/*
    func getUserInfo() {
        
        fireStoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                    }
                }
            }
        }
    }
*/
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dinnersArray.count
        
      
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.dinnerCategoryLabel.text = dinnersArray[indexPath.row].dinnerCategoryArray[0]
        
        cell.dinnerNameLabel.text = dinnersArray[indexPath.row].dinnerTitle[0]

        cell.dinnerImageLabel.sd_setImage(with: URL(string: dinnersArray[indexPath.row].imageUrl))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDinnerVC" {
            
            let destinationVC = segue.destination as! DinnerViewController
            destinationVC.selectedDinner = chosenDinner
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenDinner = self.dinnersArray[indexPath.row]
        performSegue(withIdentifier: "toDinnerVC", sender: nil)
    }
}
