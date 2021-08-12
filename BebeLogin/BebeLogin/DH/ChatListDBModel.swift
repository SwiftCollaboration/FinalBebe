//
//  ChatListDBModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

class ChatListDBModel: NSObject {
    var roomcode: String?
    var sellerEmail: String?
    var buyerEmail: String?
    var sellerNickName: String?
    var buyerNickName: String?
    var itemcode: String?
    var itemtitle: String?
    var itemimage: String?
    var message: String?
    var senddate: String?
    
    // Empty constructor
    override init() {
        
    }
    
    init(roomcode: String, sellerEmail: String, buyerEmail: String, sellerNickName:String, buyerNickName:String, itemcode:String, itemtitle:String, itemimage:String, message: String, senddate: String) {
        self.roomcode = roomcode
        self.sellerEmail = sellerEmail
        self.buyerEmail = buyerEmail
        self.sellerNickName = sellerNickName
        self.buyerNickName = buyerNickName
        self.itemcode = itemcode
        self.itemtitle = itemtitle
        self.itemimage = itemimage
        self.message = message
        self.senddate = senddate
    }
}
