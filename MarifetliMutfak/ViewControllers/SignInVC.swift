//
//  ViewController.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 10.09.2021.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != nil && passwordText.text != nil {
        
            Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.makeAlert(title: "Hata", message: "Lütfen e-mail ve parola bilgilerinizi giriniz. Kayıtlı değilseniz kayıt olunuz.")
        }

        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != nil && passwordText.text != nil {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                } else {
                    let firestore = Firestore.firestore()
                    
                    let userDictionary = ["email": self.emailText.text!, "password": self.passwordText.text!] as [String : Any]
                    
                    firestore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
//
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.makeAlert(title: "Hata", message: "Lütfen e-mail ve parola bilgilerinizi giriniz. Kayıtlı değilseniz kayıt olunuz.")
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

