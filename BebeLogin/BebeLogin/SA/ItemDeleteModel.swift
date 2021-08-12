//
//  ItemDeleteModel.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/03.
//

import Foundation

// Insert, Update, Delete할 때에는 protocol이 필요 X

class ItemDeleteModel {
    var urlPath = "http://localhost:8080/bebeProject/ItemDelete_ios.jsp" // file 경로 지정
    
    // 잘 불러왔다면 true를 return
    func deleteItems(itemCode: String) -> Bool{
        var result: Bool = true
        let urlAdd = "?itemCode=\(itemCode)" // urlPath 뒤에 붙는 주소
        urlPath = urlPath + urlAdd
        print(urlPath)
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        // Session과 URL 연결
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        // Task를 정의, Json의 전체를 가져오기 위함,
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil {
                print(url)
                print("Failed to delete item data")
                result = false
            }else {
                print(url)
                print("Data is deleted")
                result = true
            }
        }
        task.resume() // task 실행
        return result // 입력이 잘되면 true, 안되면 false를 return
    }
    
}
