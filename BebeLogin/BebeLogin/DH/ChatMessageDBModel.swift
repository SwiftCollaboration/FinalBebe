//
//  ChatMessageDBModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

class ChatMessageDBModel: NSObject {
    var user_email: String?
    var message: String?
    var senddate: String?
    
    // Empty constructor
    override init() {
        
    }
    
    init(user_email: String, message: String, senddate: String) {
        self.user_email = user_email
        self.message = message
        self.senddate = senddate
    }
}
