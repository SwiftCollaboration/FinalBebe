//
//  ChatMessageSelectModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

protocol ChatMessageSelectModelProtocol {
    func itemDeownloaded(items: NSArray)
}

class ChatMessageSelectModel: NSObject {
    var delegate: ChatMessageSelectModelProtocol!
    var urlPath = share.url("chat.jsp")
    
    func chatMessageSelectItems(_ roomcode: String) {
        
        urlPath = urlPath + "?roomcode=\(roomcode)"
        
        print(urlPath)
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data is downloaded")
                self.parseQuery(data!)
            }
        }
        task.resume()
    }
    
    func parseQuery(_ data: Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            if let user_email = jsonElement["user_email"] as? String,
               let message = jsonElement["message"] as? String,
               let senddate = jsonElement["senddate"] as? String {
                let query = ChatMessageDBModel(user_email: user_email, message: message, senddate: senddate)
                locations.add(query)
                
                print(message)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDeownloaded(items: locations)
        })
    }
}
