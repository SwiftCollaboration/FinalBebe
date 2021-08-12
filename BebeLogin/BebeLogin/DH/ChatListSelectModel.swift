//
//  ChatListSelectModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

let share = Share()

protocol ChatListSelectModelProtocol {
    func itemDeownloaded(items: NSArray)
}

class ChatListSelectModel: NSObject {
    var delegate: ChatListSelectModelProtocol!
    var urlPath = share.url("chat_list.jsp")
    
    func chatListSelectItems() {
        
        urlPath = urlPath + "?email=\(Share.userCode)"
        
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
            if let roomcode = jsonElement["roomcode"] as? String,
               let sellerEmail = jsonElement["sellerEmail"] as? String,
               let buyerEmail = jsonElement["buyerEmail"] as? String,
               let sellerNickName = jsonElement["sellerNickName"] as? String,
               let buyerNickName = jsonElement["buyerNickName"] as? String,
               let itemcode = jsonElement["itemcode"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let itemimage = jsonElement["itemimage"] as? String,
               let message = jsonElement["message"] as? String,
               let senddate = jsonElement["senddate"] as? String {
                let query = ChatListDBModel(roomcode: roomcode, sellerEmail: sellerEmail, buyerEmail: buyerEmail, sellerNickName: sellerNickName, buyerNickName: buyerNickName, itemcode: itemcode, itemtitle: itemtitle, itemimage: itemimage, message: message, senddate: senddate)
                locations.add(query)
                
                print(message)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDeownloaded(items: locations)
        })
    }
}
