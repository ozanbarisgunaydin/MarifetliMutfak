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
    var selectedRow : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        dinnerTitle.text = selectedDinner?.dinnerTitle[selectedRow]
        category.text = selectedDinner?.dinnerCategory
        dinnerHow.text = selectedDinner?.description[selectedRow]
        mat1.text = selectedDinner?.dinnerMaterial1[selectedRow]
        int1.text = selectedDinner?.dinnerInt1[selectedRow]
        unit1.text = selectedDinner?.dinnerUnit1[selectedRow]
        mat2.text = selectedDinner?.dinnerMaterial2[selectedRow]
        int2.text = selectedDinner?.dinnerInt2[selectedRow]
        unit2.text = selectedDinner?.dinnerUnit2[selectedRow]
        mat3.text = selectedDinner?.dinnerMaterial3[selectedRow]
        int3.text = selectedDinner?.dinnerInt3[selectedRow]
        unit3.text = selectedDinner?.dinnerUnit3[selectedRow]
        mat4.text = selectedDinner?.dinnerMaterial4[selectedRow]
        int4.text = selectedDinner?.dinnerInt4[selectedRow]
        unit4.text = selectedDinner?.dinnerUnit4[selectedRow]
        dinnerImage.kf.setImage(with: URL(string: selectedDinner!.imageUrlArray[selectedRow]))
        
    }
}
