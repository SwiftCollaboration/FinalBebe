//
//  Share.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/02.
//

import Foundation


struct Share {
    static var userEmail = ""
    static var userNickName = ""
    static var ipaddress = "192.168.0.127:8080" //김민재
    static var withdrawal = "" //김민재
    static var trueFalseOfPassword = "" //김민재
    
    // 이도희
    static var userCode = "user"
    
    //******* IP 쓴 채로 push 안하도록 주의!! <<<<<<<<<< 보안!!!!!!!
    func url(_ fileName: String) -> String{
        let url = "http://192.168.0.127:8080/bebeProject/\(fileName)"
        return url
    }
    
    func imgUrl(_ fileName: String) -> String{
        let url = "http://192.168.0.127:8080/bebeProject/image/\(fileName)"
        return url
    }
}
