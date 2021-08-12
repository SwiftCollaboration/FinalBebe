//
//  ItemDetailQueryModel.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/02.
//

import Foundation


// Json Data를 넘겨주기 위한 Protocol
protocol ItemDetailQueryModelProtocol {
    func itemDownloaded(items: NSMutableArray) // 배열 생성, NSArray는 한번 생성되면 값을 바꿀 수 없음
    // 함수 이름만 존재, 기능은 TableViewController.swift에서
}


class ItemDetailQueryModel {
    var delegate: ItemDetailQueryModelProtocol! // Protocol
    var urlPath = "http://localhost:8080/bebeProject/ItemDetailQuery_ios.jsp" // file 경로 지정
    
    // async
    func downloadItems(itemCode: String) {
        let urlAdd = "?itemCode=\(itemCode)"
        urlPath = urlPath + urlAdd
        print(urlPath)
        let url: URL = URL(string: urlPath)!
        // Session과 URL 연결
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        // Task를 정의, Json의 전체를 가져오기 위함,
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data is downloaded")
                self.parseJSON(data!) // parseJSON에 data를 넣어줌
            }
        }
        task.resume() // task 실행
    }
    
    func parseJSON(_ data: Data) {
        print("parseJSON start")
        var jsonResult = NSArray() // json 데이터를 저장할 배열, 여러가지 자료형을 쓰기 위해 NSArray를 씀
        do {
            // Json에서 Data를 불러옴 -> NSArray로 변환
            // jsonResult에선 json의 {} 의 값을 Data 1개로 취급한다
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary() // (Key, Value) 값으로 저장하기 위한 Dictionary
        let locations = NSMutableArray() // ArrayList와 같음, 데이터 삽입&수정&삭제가 가능하도록 NSMutableArray로 설정
        
        for i in 0..<jsonResult.count{
            // json의 {} 의 값을 Data 1개로 취급한다
            jsonElement = jsonResult[i] as! NSDictionary // jsonResult를 NSDictionary로 변환 :: (Key, Value) 값으로 구성하기 위하여
            if let category = jsonElement["category"] as? String, // json의 "code"의 값을 불러옴, "code" : "S001"
               let useAge = jsonElement["useAge"] as? String,
               let itemTitle = jsonElement["itemTitle"] as? String,
               let itemContent = jsonElement["itemContent"] as? String,
               let itemImage = jsonElement["itemImage"] as? String,
               let itemPrice = jsonElement["itemPrice"] as? String,
               let userNickname = jsonElement["userNickname"] as? String,
               let address = jsonElement["address"] as? String,
               let tag = jsonElement["tag"] as? String,
               let dealCompleteDate = jsonElement["dealCompleteDate"] as? String,
               let deleteDate = jsonElement["deleteDate"] as? String,
               let user_email = jsonElement["user_email"] as? String{
                // let 변수 scode, sname, sdept, sphone이 이상이 없으면
                // DBModel 생성자를 통하여 Data를 query 변수에 넣어줌
                let query = ItemDBModel(category: category, useAge: useAge, itemTitle: itemTitle, itemContent: itemContent, itemImage: itemImage, itemPrice: itemPrice, userNickname: userNickname, address: address, tag: tag, dealCompleteDate: dealCompleteDate, deleteDate: deleteDate, user_email: user_email)
                locations.add(query) // NSMutableArray(locations)에 Data를 넣어줌
            }
        }
        
        print("locations is \(locations)")
        
        DispatchQueue.main.async(execute: {() -> Void in // item 다운로드 시, 위의 코드를 실행
            // locations와 async, 12행 참고, async는 다중 작업을 가능하게 함
            // TableViewController 실행 시, JsomModel.swift도 같이 실행되게끔 함
            self.delegate.itemDownloaded(items: locations) // 딕셔너리와 연결
        })
    }
}

