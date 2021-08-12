//
//  ReviewInsertModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

protocol ReviewInsertModelProtocol {
    func itemDeownloaded(items: String)
}

class ReviewInsertModel: NSObject {
    var delegate: ReviewInsertModelProtocol!
    var urlPath = share.url("review.jsp")
    
    func reviewInsertItems(_ itemcode: String, _ score: Int, _ scoreType: String, _ sellerEmail: String, _ buyerEmail: String, _ scoreEmail: String) {
        
        let urlAdd = "?itemcode=\(itemcode)&score=\(score)&scoreType=\(scoreType)&sellerEmail=\(sellerEmail)&buyerEmail=\(buyerEmail)&scoreEmail=\(scoreEmail)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
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
            if let result = jsonElement["result"] as? String {
                locations = result
                
                print("result : " + result)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDeownloaded(items: locations)
        })
    }
}
