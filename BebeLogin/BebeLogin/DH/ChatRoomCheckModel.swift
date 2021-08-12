//
//  ChatRoomCheckModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

protocol ChatRoomCheckModelProtocol {
    func itemDeownloaded(items: String)
}

class ChatRoomCheckModel: NSObject {
    var delegate: ChatRoomCheckModelProtocol!
    var urlPath = share.url("chat_roomCheck.jsp")
    
    func chatRoomCheckItems(_ seller: String, _ buyer: String, _ itemcode: String) {
        
        urlPath = urlPath + "?seller=\(seller)&buyer=\(buyer)&itemcode=\(itemcode)"
        
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
        var locations = ""
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            if let roomcode = jsonElement["roomcode"] as? String {
                locations = roomcode
                
                print("roomcode : " + roomcode)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDeownloaded(items: locations)
        })
    }
}
