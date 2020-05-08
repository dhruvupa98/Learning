//
//  ModelClass.swift
//  newcore
//
//  Created by Dhruv Upadhyay on 29/01/20.
//  Copyright © 2020 Dhruv Upadhyay. All rights reserved.
//

import Foundation
import UIKit
class Movies: Decodable
{
    var collectionName: String?
    var trackName: String?
    var artworkUrl60: String?
    
    init(collectionName : String, trackName : String, artworkUrl60:String){
        self.collectionName = collectionName
        self.trackName = trackName
        self.artworkUrl60 = artworkUrl60
        
    }
    
    
}
