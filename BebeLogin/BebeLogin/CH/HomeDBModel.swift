//
//  HomeDBModel.swift
//  BabyProject
//
//  Created by 이찬호 on 2021/07/31.
//

import Foundation

class HomeDBModel: NSObject{
    var itemtitle: String?
    var itemimage: String?
    var address: String?
    var useage: String?
    var itemcode: String?
    
    // Empty constructor
    override init() {
        
    }
    
    init(itemtitle: String, itemimage: String, address: String, useage: String, itemcode: String) {
        self.itemtitle = itemtitle
        self.itemimage = itemimage
        self.address = address
        self.useage = useage
        self.itemcode = itemcode
    }
}
