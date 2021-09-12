//
//  AddVC.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit
import Firebase
import MultilineTextField

class AddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
 
    

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
    
    var selectedTextField : UITextField?
    var pickerView = UIPickerView()

    
    var selectedUnit: String?
    let unitArray = ["Litre", "Kilogram", "Yemek Kaşığı", "Çay Kaşığı", "Su Bardağı", "Çay Bardağı", "Adet"]
    let categoryArray = ["Hamur İşleri", "Tatlılar", "İçecekler", "Tencere Yemekleri", "Çorbalar", "Ara Sıcaklar", "Kahvaltılıklar", "Et Yemekleri", "Tavuk Yemekleri"]
    
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
        
        createPickerView()
        dismissPickerView()
  
        
    }
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
 
    @IBAction func addButtonClicked(_ sender: Any) {
        
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
                            let imageUrl = url?.absoluteString
                            
                            let dinnerDescription = self.howCanCook.text
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
                            let dinnercategoryArray = self.dinnerCategory.text
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Recipes").whereField("writer", isEqualTo: UserSingleton.sharedUserInfo.email!).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        let documentNumber = snapshot?.count
                                        var variable = 1
                                        
                                        for document in snapshot!.documents {
                                            
                                            
                                            let dinner = document.data()["dinnercategoryArray"]! as! [Any]
                                            
                                            if "\(dinner[0])" == dinnercategoryArray {
                                                print("1")
                                            let documentId = document.documentID
                                            
                                            if var dinnercategoryArray = document.get("dinnercategoryArray") as? [String] {
                                                dinnercategoryArray.append(self.dinnerCategory!.text!)
                                                print("2")
                                                if var dinnerTitle = document.get("dinnerTitle") as? [String] {
                                                    dinnerTitle.append(self.dinnerTitle!.text!)
                                                    print("3")
                                                    let additionalDictionary = ["dinnercategoryArray" : dinnercategoryArray, "dinnerTitle": dinnerTitle] as [String : Any]
                                                 
                                                    fireStore.collection("Recipes").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                        
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "Group 1.png")
                                                            }
                                                        }
                                                    }
                                                }
                                                break
                                            } else if documentNumber != variable {
                                                variable += 1
                                            } else {
                                                print("4")
                                                let recipeDictionary = ["dinnerTitle": [dinnerTitle!], "dinnercategoryArray": [dinnercategoryArray!], "imageUrl": imageUrl!, "date": FieldValue.serverTimestamp(), "dinnerDescription": String(dinnerDescription!), "material1": String(material1!), "Int1": String(int1!), "unit1": String(unit1!), "material2": String(material2!), "Int2": String(int2!), "unit2": String(unit2!), "material3": String(material3!), "Int3": String(int3!), "unit3": String(unit3!), "material4": String(material4!), "Int4": String(int4!), "unit4": String(unit4!), "writer": UserSingleton.sharedUserInfo.email!] as [String : Any]
                                                
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
                                        print("5")
                                        let recipeDictionary = ["dinnerTitle": [dinnerTitle!], "dinnercategoryArray": [dinnercategoryArray!], "imageUrl": imageUrl!, "date": FieldValue.serverTimestamp(), "dinnerDescription": String(dinnerDescription!), "material1": String(material1!), "Int1": String(int1!), "unit1": String(unit1!), "material2": String(material2!), "Int2": String(int2!), "unit2": String(unit2!), "material3": String(material3!), "Int3": String(int3!), "unit3": String(unit3!), "material4": String(material4!), "Int4": String(int4!), "unit4": String(unit4!), "writer": UserSingleton.sharedUserInfo.email!] as [String : Any]
                                        
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
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
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
        
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        pickerView.dataSource = self

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

