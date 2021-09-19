//
//  DinnerViewModel.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 19.09.2021.
//

import Foundation

struct DinnerViewModel {
    
    let dinners: Dinners?
    
        init(dinners: Dinners) {
    
            self.dinners = dinners
        }
        var categoryText: String? {
        
            return dinners?.dinnerCategory
        
        }
    
    
}
