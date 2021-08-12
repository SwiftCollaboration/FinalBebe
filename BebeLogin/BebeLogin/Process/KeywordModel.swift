//
//  KeywordModel.swift
//  BebeLogin
//
//  Created by 박재원 on 2021/08/05.
//

import Foundation

protocol KeywordModelProtocol {
    func itemDownloaded(items: NSArray)
}

class KeywordModel{
    
    var delegate: KeywordModelProtocol!
    //let urlPath = "http://172.20.10.6:8080/bebeproject/searchkeyword_query.jsp"
    let urlPath = Share().url("searchkeyword_query.jsp")
    
    func downloadItems(){
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJSON(data!)
            }
            
        } // task
        task.resume()
    } // download
    
    func parseJSON(_ data: Data) {
        print("Start parseJSON")
        // 배열만들기 -> Dictionary 만들기 -> Dic 빼서 각각 배열에 저장하기
        
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                // 들어오는 값을 NSArray로 바꾼다. [  ,  , ] 이런식으로 바꿔줌
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        print("Check1")
        for i in 0..<jsonResult.count{
            // Json 형태가 Kay&Value 형태로 되어있어서 그렇다.
            jsonElement = jsonResult[i] as! NSDictionary
            if let itemcode = jsonElement["itemcode"] as? String,
               let useage = jsonElement["useage"] as? String,
               let tag = jsonElement["tag"] as? String{
                // 이상이 없으면 넣어준다.
                let query = KeywordDBModel(itemcode: itemcode, useage: useage, tag: tag)
               
                locations.add(query)
            }
            
        } // for
        print("Check2")
        // 데이터를 TableView에 넘겨주려고 하는데 그때 다른 작업을 TableView하고있다? -> 충돌남
        // 그 상황을 처리하기위해서는 비동기 방식을 사용해야한다.
        // tableView에서 작업하는 것과 동시에 이루어진다 = Async
        DispatchQueue.main.async(execute: {() -> Void in
            // delegate = JsonModelProtocol
            self.delegate.itemDownloaded(items: locations)
        })
    }
    
} // KeywordModel
