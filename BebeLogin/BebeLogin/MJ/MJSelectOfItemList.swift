//
//  MJSelectOfItemList.swift
//  BabyProject
//
//  Created by 김민재 on 2021/08/02.
//

import Foundation

protocol MJSelectOfItemListProtocol {
    func itemDownloaded(items: NSArray)
}


//---------구입내역 (거래중)----------------------------------------------------------
class MJSelectOfItemListIsNull{
    

    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_buyList_select.jsp"
    
    func downloadItems(){
        //print(Share.userEmail)
        let urlAdd = "?userEmail=\(Share.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                //print(url)
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                //print("itemimage =", itemimage, "itemtitle =", itemtitle, "usernickname =", usernickname, "address =", address, "useage =", useage, "itemcode =", itemcode)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: "0")
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

//---------구입내역 (거래완료)----------------------------------------------------------
class MJSelectOfItemListIsNotNull{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_buyList_end_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(Share.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                //print(url)
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                //print("itemimage =", itemimage, "itemtitle =", itemtitle, "usernickname =", usernickname, "address =", address, "useage =", useage, "itemcode =", itemcode)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: "0")
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

//---------판매내역 (거래중)----------------------------------------------------------
class MJSelectOfSellItemListIsNull{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_sellList_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(MJShopOfSelect.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                ////print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                //print(url)
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                //print("itemimage =", itemimage, "itemtitle =", itemtitle, "usernickname =", usernickname, "address =", address, "useage =", useage, "itemcode =", itemcode)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: "0")
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

//---------판매내역 (거래완료)----------------------------------------------------------
class MJSelectOfSellItemListIsNotNull{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_sellList_end_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(MJShopOfSelect.userEmail)"
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                //print("itemimage =", itemimage, "itemtitle =", itemtitle, "usernickname =", usernickname, "address =", address, "useage =", useage, "itemcode =", itemcode)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: "0")
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}


//---------후기내역 (작성된후기)----------------------------------------------------------
class MJSelectOfReviewItemListIsNotZero{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_reviewList_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(Share.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded-------------------------------")
                //print(url)
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                //print("itemimage =", itemimage, "itemtitle =", itemtitle, "usernickname =", usernickname, "address =", address, "useage =", useage, "itemcode =", itemcode)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: "0")
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

//---------후기내역 (미작성 후기)----------------------------------------------------------
class MJSelectOfReviewItemListIsZero{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_reviewList_end_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(Share.userEmail)"
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String{
                //print("itemimage =", itemimage, "itemtitle =", itemtitle, "usernickname =", usernickname, "address =", address, "useage =", useage, "itemcode =", itemcode)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: "0")
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}


//---------구입내역 후기점수 리스트 (거래완료)----------------------------------------------------------
class MJMyShopOfBuyList{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_myShop_buyList_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(MJShopOfSelect.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        //print(url)
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded123-------------------------------")
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String,
               let itemScore = jsonElement["itemScore"] as? String{
                //print("itemimage:", itemimage, "itemtitle:", itemtitle, "usernickname:", usernickname, "address:", address, "useage:", useage, "itemcode:", itemcode, "itemScore:", itemScore)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: itemScore)
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

//---------판매내역 후기점수 리스트 (거래완료)----------------------------------------------------------
class MJMyShopOfSellList{
    
    var delegate:MJSelectOfItemListProtocol!
    var urlPath = "http://\(Share.ipaddress)/bebeProject/bebegoods_myShop_sellList_select.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(MJShopOfSelect.userEmail)"
        let url: URL = URL(string: urlPath + urlAdd)!
        //print(url)
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                //print("Failed to download data---------------------------")
            }else{
                //print("Data is downloaded321-------------------------------")
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
            if let itemimage = jsonElement["itemimage"] as? String,
               let itemtitle = jsonElement["itemtitle"] as? String,
               let usernickname = jsonElement["usernickname"] as? String,
               let address = jsonElement["address"] as? String,
               let useage = jsonElement["useage"] as? String,
               let itemcode = jsonElement["itemcode"] as? String,
               let itemScore = jsonElement["itemScore"] as? String{
                //print("itemimage:", itemimage, "itemtitle:", itemtitle, "usernickname:", usernickname, "address:", address, "useage:", useage, "itemcode:", itemcode, "itemScore:", itemScore)
                let query = MJDBItemlist(itemimage: itemimage, itemtitle: itemtitle, usernickname: usernickname, address: address, useage: useage, itemcode: itemcode, itemScore: itemScore)
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}
