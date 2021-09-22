//
//  AddVC.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit
import Firebase
import MultilineTextField

class AddVC: UIViewController {
 

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var dinnerTitle: UITextField!
    @IBOutlet weak var howCanCook: MultilineTextField!
    
    @IBOutlet weak var material1: UITextField!
    @IBOutlet weak var unit1: UITextField!
    @IBOutlet weak var int1: UITextField!
    
    @IBOutlet weak var material2: UITextField!
    @IBOutlet weak var unit2: UITextField!
    @IBOutlet weak var int2: UITextField!
    
    @IBOutlet weak var material3: UITextField!
    @IBOutlet weak var unit3: UITextField!
    @IBOutlet weak var int3: UITextField!
    
    @IBOutlet weak var material4: UITextField!
    @IBOutlet weak var unit4: UITextField!
    @IBOutlet weak var int4: UITextField!
    
    @IBOutlet weak var dinnerCategory: UITextField!
    
    private var selectedTextField : UITextField?
    private var pickerView = UIPickerView()

    private var selectedUnit: String?
    private let unitArray = ["Litre", "Kilogram", "Yemek Kaşığı", "Çay Kaşığı", "Su Bardağı", "Çay Bardağı", "Adet"]
    private let categoryArray = ["Hamur İşleri", "Tatlılar", "İçecekler", "Tencere Yemekleri", "Çorbalar", "Ara Sıcaklar", "Kahvaltılıklar", "Et Yemekleri", "Tavuk Yemekleri"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }

        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
        
        unit1.delegate = self
        unit2.delegate = self
        unit3.delegate = self
        unit4.delegate = self
        dinnerCategory.delegate = self
        
        createPickerView()
        dismissPickerView()
  
        
    }
    @IBAction private func addButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("Media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                } else {
                    imageReferance.downloadURL { url, error in
                        if error == nil {
                            
                            let dinnerCategory = self.dinnerCategory.text
                            let imageUrl = url?.absoluteString
                            let description = self.howCanCook.text
                            let dinnerTitle = self.dinnerTitle.text
                            let material1 = self.material1.text
                            let unit1 = self.unit1.text
                            let int1 = self.int1.text
                            let material2 = self.material2.text
                            let unit2 = self.unit2.text
                            let int2 = self.int2.text
                            let material3 = self.material3.text
                            let unit3 = self.unit3.text
                            let int3 = self.int3.text
                            let material4 = self.material4.text
                            let unit4 = self.unit4.text
                            let int4 = self.int4.text

                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Recipes").whereField("writer", isEqualTo: UserSingleton.sharedUserInfo.email!).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        let documentNumber = snapshot?.count
                                        var variable = 1
                                        
                                        for document in snapshot!.documents {
                                            
                                            
                                            let dinner = document.data()["dinnerCategory"]!
                                            
                                            if "\(dinner)" == dinnerCategory {
                                                
                                            let documentId = document.documentID

                                            if var dinnerTitle = document.get("dinnerTitle") as? [String] {
                                                dinnerTitle.append(self.dinnerTitle!.text!)
                                                
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                            if var description = document.get("dinnerDescription") as? [String] {
                                                description.append(self.howCanCook!.text!)
                                                
                                            if var material1 = document.get("material1") as? [String] {
                                                material1.append(self.material1!.text!)
                                                
                                            if var unit1 = document.get("unit1") as? [String] {
                                                unit1.append(self.unit1!.text!)
                                               
                                            if var int1 = document.get("Int1") as? [String] {
                                                int1.append(self.int1!.text!)
                                               
                                                if var material2 = document.get("material2") as? [String] {
                                                    material2.append(self.material2!.text!)
                                                    
                                                if var unit2 = document.get("unit2") as? [String] {
                                                    unit2.append(self.unit2!.text!)
                                                   
                                                if var int2 = document.get("Int2") as? [String] {
                                                    int2.append(self.int2!.text!)
                                                   
                                                    if var material3 = document.get("material3") as? [String] {
                                                        material3.append(self.material3!.text!)
                                                     
                                                    if var unit3 = document.get("unit3") as? [String] {
                                                        unit3.append(self.unit3!.text!)
                                                      
                                                    if var int3 = document.get("Int3") as? [String] {
                                                        int3.append(self.int3!.text!)
                                                       
                                                        if var material4 = document.get("material4") as? [String] {
                                                            material4.append(self.material4!.text!)
                                                          
                                                        if var unit4 = document.get("unit4") as? [String] {
                                                            unit4.append(self.unit4!.text!)
                                                           
                                                        if var int4 = document.get("Int4") as? [String] {
                                                            int4.append(self.int4!.text!)
                                                       
                                                            let additionalDictionary = ["dinnerTitle": dinnerTitle, "imageUrlArray": imageUrlArray, "dinnerDescription": description, "material1": material1, "Int1": int1, "unit1": unit1, "material2": material2, "Int2": int2, "unit2": unit2, "material3": material3, "Int3": int3, "unit3": unit3, "material4": material4, "Int4": int4, "unit4": unit4] as [String : Any]
                                                 
                                                    fireStore.collection("Recipes").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                        
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "Group 1.png")
                                        

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
                                                break
                                            } else if documentNumber != variable {
                                                variable += 1
                                            } else {
                                          
                                                let recipeDictionary = ["dinnerTitle": [dinnerTitle!], "dinnerCategory": dinnerCategory!, "imageUrlArray": [imageUrl!], "date": FieldValue.serverTimestamp(), "dinnerDescription": [description!], "material1": [material1!], "Int1": [int1!], "unit1": [unit1!], "material2": [material2!], "Int2": [int2!], "unit2": [unit2!], "material3": [material3!], "Int3": [int3!], "unit3": [unit3!], "material4": [material4!], "Int4": [int4!], "unit4": [unit4!], "writer": UserSingleton.sharedUserInfo.email!] as [String : Any]
                                                
                                                    fireStore.collection("Recipes").addDocument(data: recipeDictionary) { (error) in
                                                    
                                                    if error != nil {
                                                        
                                                        self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                                                        
                                                    } else  {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "Group 1.png")
                                                        
                                                    }
                                                }
                                            }
                                        } 
                                    } else {
                          
                                        let recipeDictionary = ["dinnerTitle": [dinnerTitle!], "dinnerCategory": dinnerCategory!, "imageUrlArray": [imageUrl!], "date": FieldValue.serverTimestamp(), "dinnerDescription": [description!], "material1": [material1!], "Int1": [int1!], "unit1": [unit1!], "material2": [material2!], "Int2": [int2!], "unit2": [unit2!], "material3": [material3!], "Int3": [int3!], "unit3": [unit3!], "material4": [material4!], "Int4": [int4!], "unit4": [unit4!], "writer": UserSingleton.sharedUserInfo.email!] as [String : Any]
                                            
                                            fireStore.collection("Recipes").addDocument(data: recipeDictionary) { (error) in
                                            
                                            if error != nil {
                                                
                                                self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                                                
                                            } else  {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(named: "Group 1.png")
                                                      
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

extension AddVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func choosePicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextField == unit1 || selectedTextField == unit2 || selectedTextField == unit3 || selectedTextField == unit4   {
            return unitArray.count
        } else {
            return categoryArray.count
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextField == unit1 || selectedTextField == unit2 || selectedTextField == unit3 || selectedTextField == unit4   {
            return unitArray[row]
        } else {
            return categoryArray[row]
        }
        
    }
        
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        if selectedTextField == unit1 {
            selectedUnit = unitArray[row]
            unit1.text = selectedUnit
        } else if selectedTextField == unit2 {
            selectedUnit = unitArray[row]
            unit2.text = selectedUnit
        } else if selectedTextField == unit3 {
            selectedUnit = unitArray[row]
            unit3.text = selectedUnit
        } else if selectedTextField == unit4 {
            selectedUnit = unitArray[row]
            unit4.text = selectedUnit
        } else{
            selectedUnit = categoryArray[row]
            dinnerCategory.text = selectedUnit
        }
        pickerView.reloadAllComponents()

    }

    func createPickerView() {

        unit1.inputView = pickerView
        unit2.inputView = pickerView
        unit3.inputView = pickerView
        unit4.inputView = pickerView
        dinnerCategory.inputView = pickerView
        
    }
    
    func dismissPickerView() {
        
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Seç", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        unit1.inputAccessoryView = toolBar
        unit2.inputAccessoryView = toolBar
        unit3.inputAccessoryView = toolBar
        unit4.inputAccessoryView = toolBar
        dinnerCategory.inputAccessoryView = toolBar
        
    }
    @objc func action() {
          view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        self.selectedTextField = textField
       
    }

    
}
