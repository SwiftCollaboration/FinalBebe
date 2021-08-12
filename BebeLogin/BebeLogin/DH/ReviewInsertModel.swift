//
//  ReviewInsertModel.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import Foundation

class ReviewInsertModel: NSObject {
    var urlPath = share.url("review.jsp")
    
    func reviewInsertItems(_ itemcode: String, _ score: Int, _ scoreType: String, _ sellerEmail: String, _ buyerEmail: String, _ scoreEmail: String) -> Bool {
        var result: Bool = true
        let urlAdd = "?itemcode=\(itemcode)&score=\(score)&scoreType=\(scoreType)&sellerEmail=\(sellerEmail)&buyerEmail=\(buyerEmail)&scoreEmail=\(scoreEmail)"
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
