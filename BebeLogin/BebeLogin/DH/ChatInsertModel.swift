//
//  ChatInsertModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

class ChatInsertModel: NSObject {
    var urlPath = share.url("chat_send.jsp")
    
    func insertItems(_ message: String, _ userCode: String, _ roomcode: String) -> Bool {
        var result: Bool = true
        let urlAdd = "?message=\(message)&userCode=\(userCode)&roomcode=\(roomcode)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Failed to download data")
                result = false
            }else {
                print("Data is inserted")
                result = true
            }
        }
        task.resume()
        return result
    }
    
}
