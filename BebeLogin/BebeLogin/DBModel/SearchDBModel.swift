//
//  SearchDBModel.swift
//  BebeLogin
//
//  Created by 박재원 on 2021/08/05.
//

import Foundation

class SearchDBModel: NSObject{
    
    /// Property
    var itemcode: String?
    var category: String?
    var useage: String?
    var itemtitle: String?
    var itemimage: String?
    var usernickname: String?
    var address: String?
    var tag: String?
    var uploaddate: String?
    
    /// Empty Constructor
    override init() {
    }
    
    /// Constructor
    init(itemcode: String, category: String, useage: String, itemtitle: String, itemimage: String, usernickname: String, address: String, tag: String, uploaddate: String) {
        
        self.itemcode = itemcode
        self.category = category
        self.useage = useage
        self.itemtitle = itemtitle
        self.itemimage = itemimage
        self.usernickname = usernickname
        self.address = address
        self.tag = tag
        self.uploaddate = uploaddate
     
    }
    
} // SearchDBModel
