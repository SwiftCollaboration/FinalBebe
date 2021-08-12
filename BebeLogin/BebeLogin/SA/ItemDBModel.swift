//
//  ItemDBModel.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/02.
//

import Foundation

// JAVA의 Bean과 같음
// Json 사용 시 class에 type을 주는 것이 좋음

class ItemDBModel: NSObject{ // NSObject :: 가장 큰 타입
    // 전부 다 nil 값 허용
    var category: String?
    var useAge: String?
    var itemTitle: String?
    var itemContent: String?
    var itemImage: String?
    var itemPrice: String?
    var userNickname: String?
    var address: String?
    var tag: String?
    var dealCompleteDate: String?
    var deleteDate: String?
    var user_email: String?
    
    // 생성자 생성
    // Empty constructor
    override init() {
        
    }
    
    init(category: String, useAge: String, itemTitle: String, itemContent: String, itemImage: String, itemPrice: String, userNickname: String, address: String, tag: String, dealCompleteDate: String, deleteDate: String, user_email: String) {
        self.category = category
        self.useAge = useAge
        self.itemTitle = itemTitle
        self.itemContent = itemContent
        self.itemImage = itemImage
        self.itemPrice = itemPrice
        self.userNickname = userNickname
        self.address = address
        self.tag = tag
        self.dealCompleteDate = dealCompleteDate
        self.deleteDate = deleteDate
        self.user_email = user_email
    }
    
}

