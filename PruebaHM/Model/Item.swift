//
//  Item.swift
//  PruebaHM
//
//  Created by Omar Aldair Romero Pérez on 4/9/19.
//  Copyright © 2019 Omar Aldair Romero Pérez. All rights reserved.
//

import Foundation


class Item{
    
    var title: String
    var category: String
    var lat: Double
    var lon: Double
    var imageURL: String
    
    init(title: String, category: String, lat: Double, lon: Double, imageURL: String) {
        
        self.title = title
        self.category = category
        self.lat = lat
        self.lon = lon
        self.imageURL = imageURL
    }
    
}
