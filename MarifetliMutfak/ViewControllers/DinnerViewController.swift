//
//  DinnerViewController.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit

class DinnerViewController: UIViewController {

    @IBOutlet weak var dinnerTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var mat1: UILabel!
    @IBOutlet weak var mat2: UILabel!
    @IBOutlet weak var mat3: UILabel!
    @IBOutlet weak var mat4: UILabel!
    @IBOutlet weak var int1: UILabel!
    @IBOutlet weak var int2: UILabel!
    @IBOutlet weak var int3: UILabel!
    @IBOutlet weak var int4: UILabel!
    @IBOutlet weak var unit1: UILabel!
    @IBOutlet weak var unit2: UILabel!
    @IBOutlet weak var unit3: UILabel!
    @IBOutlet weak var unit4: UILabel!
    @IBOutlet weak var dinnerHow: UILabel!
    @IBOutlet weak var dinnerImage: UIImageView!
    
    
    
    var selectedDinner : Dinners?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dinnerTitle.text = selectedDinner?.dinnerTitle[0]
        category.text = selectedDinner?.dinnerCategoryArray[0]
     
        dinnerHow.text = selectedDinner?.description
        mat1.text = selectedDinner?.dinnerMaterial1
        int1.text = selectedDinner?.dinnerInt1
        unit1.text = selectedDinner?.dinnerUnit1
        mat2.text = selectedDinner?.dinnerMaterial2
        int2.text = selectedDinner?.dinnerInt2
        unit2.text = selectedDinner?.dinnerUnit2
        mat3.text = selectedDinner?.dinnerMaterial3
        int3.text = selectedDinner?.dinnerInt3
        unit3.text = selectedDinner?.dinnerUnit3
        mat4.text = selectedDinner?.dinnerMaterial4
        int4.text = selectedDinner?.dinnerInt4
        unit4.text = selectedDinner?.dinnerUnit4

        dinnerImage.sd_setImage(with: URL(string: selectedDinner!.imageUrl))
        
        
    }
    

}
