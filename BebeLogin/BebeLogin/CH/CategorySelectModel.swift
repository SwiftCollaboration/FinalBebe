//
//  CategorySelectModel.swift
//  BabyProject
//
//  Created by 이찬호 on 2021/08/02.
//

import Foundation

protocol CategorySelectModelProtocol {
    func itemDownloaded2(items: NSArray)
}

class CategorySelectModel: NSObject{
    var delegate: CategorySelectModelProtocol!
    var urlPath = Share().url("bebeCategory_select.jsp")
    
    func downloadItems(category: String){
        let urlAdd = "?category=\(category)"
        urlPath = urlPath + urlAdd
        print(urlPath)
        
        //한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray  // json파일을 nsarray배열로 바꿔줌
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let itemtitle = jsonElement["itemtitle"] as? String,
               let itemimage = jsonElement["itemimage"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                let query = HomeDBModel(itemtitle: itemtitle, itemimage: itemimage, address: address, useage: useage, itemcode: itemcode)
                locations.add(query)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded2(items: locations)
        })
        
    }
    
}
