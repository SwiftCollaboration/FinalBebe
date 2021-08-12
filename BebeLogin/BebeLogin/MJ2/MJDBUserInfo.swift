//
//  MJDBUserInfo.swift
//  BabyProject
//
//  Created by 김민재 on 2021/07/30.
//

import Foundation

class MJDBUserInfo: NSObject{
    var email:String?, nickname:String?
    
    // Empty constructor
    override init(){
        
    }
    init(email:String, nickname:String) {
        self.email = email
        self.nickname = nickname
    }
}
