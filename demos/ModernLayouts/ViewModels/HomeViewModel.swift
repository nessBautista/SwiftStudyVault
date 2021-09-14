//
//  HomeViewModel.swift
//  ModernLayouts
//
//  Created by Nestor Hernandez on 13/06/21.
//

import Foundation
import Combine

class HomeViewModel {
    var homeItems: CurrentValueSubject<[HomeItem], Never> = CurrentValueSubject([])
    
    func loadItems() {
        homeItems.send(initHomeItems())
    }
    
    fileprivate func initHomeItems() -> [HomeItem] {
        //basic
        let item1 = HomeItem(title: "Basic Layout")
        
        
        //send items
        return [item1]
    }
}
