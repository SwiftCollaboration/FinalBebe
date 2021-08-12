//
//  MJSelectOfUserInfo.swift
//  BabyProject
//
//  Created by 김민재 on 2021/07/30.
//

import Foundation

protocol MJSelectOfUserInfoProtocol {
    func itemDownloaded(items: NSArray)
}

class MJSelectOfUserInfo{
    var delegate:MJSelectOfUserInfoProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_myPage_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?code=\(Share.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let email = jsonElement["email"] as? String,
               let nickname = jsonElement["nickname"] as? String{
                //print("email =", email, "nickname =",nickname)
                let query = MJDBUserInfo(email: email, nickname: nickname)
                Share.userEmail = email
                Share.userNickName = nickname
                MJShopOfSelect.userEmail = email
               //print(Share.userEmail, "//" ,Share.userNickName)
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

// 회원탈퇴 JSP 거래중인 항목이 있는지 검색.
class MJWithdrawalOfUserInfo{
    var delegate:MJSelectOfUserInfoProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_withdrawal_select.jsp"
    
    func downloadItems(userEmail:String){
        let urlAdd = "?userEmail=\(userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let countOfDeal = jsonElement["countOfDeal"] as? String{
                //print("countOfDeal =", countOfDeal)
                Share.withdrawal = countOfDeal
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

// 회원탈퇴 JSP 비밀번호 입력 검사
class MJWithdrawalAndPasswordTrueFalse{
    var delegate:MJSelectOfUserInfoProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_withdrawal_trueFalse.jsp"
    
    func downloadItems(trueFalseOfPassword:String){
        let urlAdd = "?trueFalseOfPassword=\(trueFalseOfPassword)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let trueFalseOfPassword = jsonElement["trueFalseOfPassword"] as? String{
                //print("trueFalseOfPassword =", trueFalseOfPassword)
                Share.trueFalseOfPassword = trueFalseOfPassword
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

// 정말 회원탈퇴 JSP
class MJRealWithdrawal{
    var delegate:MJSelectOfUserInfoProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_withdrawal_update.jsp"
    
    func userUpdate() -> Bool{
        var result : Bool = true
        let urlAdd = "?userEmail=\(Share.userEmail)"
        urlPath = urlPath + urlAdd
        //print(urlPath)
        
        //한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to Upadate data")
                result = false
            }else{
                //print("Data is Update")
                result = true
            }
        }
        task.resume()
        return result
    }
    
}


//내상점보기
class MJMyShopPage{
    var delegate:MJSelectOfUserInfoProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_myShopsPage_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?email=\(MJShopOfSelect.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        print(url)
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let email = jsonElement["email"] as? String,
               let nickname = jsonElement["nickname"] as? String,
               let signupdate = jsonElement["signupdate"] as? String,
               let score = jsonElement["score"] as? String{
                MJShopOfSelect.userEmail = email
                MJShopOfSelect.userNickName = nickname
                MJShopOfSelect.userSignUpDate = signupdate
                MJShopOfSelect.score = Int(score)!
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}
