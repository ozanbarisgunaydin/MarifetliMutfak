//
//  SettingsVC.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSigninVC", sender: nil)
            
        } catch {
            
        }
        
        
    }
    
}
