//
//  DinnerViewController.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import UIKit


class DinnerViewController: UIViewController {

    @IBOutlet private weak var dinnerTitle: UILabel!
    @IBOutlet private weak var category: UILabel!
    @IBOutlet private weak var mat1: UILabel!
    @IBOutlet private weak var mat2: UILabel!
    @IBOutlet private weak var mat3: UILabel!
    @IBOutlet private weak var mat4: UILabel!
    @IBOutlet private weak var int1: UILabel!
    @IBOutlet private weak var int2: UILabel!
    @IBOutlet private weak var int3: UILabel!
    @IBOutlet private weak var int4: UILabel!
    @IBOutlet private weak var unit1: UILabel!
    @IBOutlet private weak var unit2: UILabel!
    @IBOutlet private weak var unit3: UILabel!
    @IBOutlet private weak var unit4: UILabel!
    @IBOutlet private weak var dinnerHow: UILabel!
    @IBOutlet private weak var dinnerImage: UIImageView!
    
    
    
    var selectedDinner : Dinners?


    override func viewDidLoad() {
        super.viewDidLoad()

        dinnerTitle.text = selectedDinner?.dinnerTitle[0]
        category.text = selectedDinner?.dinnerCategory
     
        dinnerHow.text = selectedDinner?.description[0]
        mat1.text = selectedDinner?.dinnerMaterial1[0]
        int1.text = selectedDinner?.dinnerInt1[0]
        unit1.text = selectedDinner?.dinnerUnit1[0]
        mat2.text = selectedDinner?.dinnerMaterial2[0]
        int2.text = selectedDinner?.dinnerInt2[0]
        unit2.text = selectedDinner?.dinnerUnit2[0]
        mat3.text = selectedDinner?.dinnerMaterial3[0]
        int3.text = selectedDinner?.dinnerInt3[0]
        unit3.text = selectedDinner?.dinnerUnit3[0]
        mat4.text = selectedDinner?.dinnerMaterial4[0]
        int4.text = selectedDinner?.dinnerInt4[0]
        unit4.text = selectedDinner?.dinnerUnit4[0]

        dinnerImage.sd_setImage(with: URL(string: selectedDinner!.imageUrlArray[0]))
    
    }
}
