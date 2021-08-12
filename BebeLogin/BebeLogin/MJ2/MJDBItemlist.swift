//
//  MJDBItemlist.swift
//  BabyProject
//
//  Created by 김민재 on 2021/08/02.
//
//select itemtitle, address, useage from item where dealcompletedate is null AND item_usercode = '2';
//select itemtitle, address, useage from item where dealcompletedate is not null AND item_usercode = '2';



import Foundation

class MJDBItemlist: NSObject{
    var itemimage:String?, itemtitle:String?, usernickname:String?, address:String?, useage:String?, itemcode:String?
    
    // Empty constructor
    override init(){
        
    }
    init(itemimage:String, itemtitle:String, usernickname:String, address:String, useage:String, itemcode:String) {
        self.itemimage = itemimage
        self.itemtitle = itemtitle
        self.usernickname = usernickname
        self.address = address
        self.useage = useage
        self.itemcode = itemcode
    }
}
