//
//  Friend.swift
//  NearFriend
//
//  Created by MobileDev on 10/31/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit

class Friend{
    var name:String
    var latitude:Double
    var longitude:Double
    var imageUrl:String
    
    init(name: String, latitude: Double, longitude: Double, imageUrl: String){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrl = imageUrl
        
    }
    
    init(){
        self.name = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.imageUrl = ""
        
    }
}
