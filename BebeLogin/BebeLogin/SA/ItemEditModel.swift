//
//  ItemEditModel.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/04.
//

import Foundation

// Insert, Update, Delete할 때에는 protocol이 필요 X

class ItemEditModel:NSObject {
    var share = Share()
    var urlPath = "http://192.168.0.127/bebeProject/ItemEdit_ios.jsp" // file 경로 지정
    
    // MARK: Img Upload
    func itemEdit(with fileURL: URL, parameters: [String: String]?) -> Data? {
        // 파일을 읽을 수 없다면 nil을 리턴
        guard let filedata = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        // 바운더리 값을 정하고,
        // 각 파트의 헤더가 될 라인들을 배열로 만든다.
        // 이 배열을 \r\n 으로 조인하여 한 덩어리로 만들어서
        // 데이터로 인코딩한다.
        let boundary = "XXXXX"
        let mimetype = "image/jpeg"
        let headerLines = ["--\(boundary)",
            "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"",
            "Content-Type: \(mimetype)",
            "\r\n"]
        var data = headerLines.joined(separator:"\r\n").data(using:.utf8)!
        itemEdit_itemimage = fileURL.lastPathComponent
        print("fileName is \(itemEdit_itemimage)")
        
        
        // 그 다음에 파일 데이터를 붙이고
        data.append(contentsOf: filedata)
        data.append(contentsOf: "\r\n".data(using: .utf8)!)
        
        // 일반적인 데이터 넣을때 사용하는 폼
        // --\(boundary)\r\n
        // Content-Disposition: form-data; name=\"값\"\r\n\r\n
        // 내용\r\n
        let lines = ["--\(boundary)","Content-Disposition: form-data; name=\"name\"\r\n","values\r\n"]
        data.append(contentsOf: lines.joined(separator: "\r\n").data(using: .utf8)!)
        
        if parameters != nil {
            for (key, value) in parameters! {
                let lines = ["--\(boundary)","Content-Disposition: form-data; name=\"\(key)\"\r\n","\(value)\r\n"]
                data.append(contentsOf: lines.joined(separator: "\r\n").data(using: .utf8)!)
            }
        }
        
        
        // 마지막으로 데이터의 끝임을 알리는 바운더리를 한 번 더 사용한다.
        // 이는 '새로운 개행'이 필요하므로 앞에 \r\n이 있어야 함에 유의 한다.
        data.append(contentsOf: "\r\n--\(boundary)--".data(using:.utf8)!)
        return data
    }
    
    func uploadImageFile(at filepath: URL, completionHandler: @escaping(Data?, URLResponse?) -> Void) {
        
        // 경로를 준비하고
        //let url = URL(string: "\(filepath), ImageUpload.jsp")!
        let urlStr = "http://localhost:8080/bebeProject/ItemEdit_ios.jsp?category=\(itemEdit_category)&useAge=\(itemEdit_useage)&itemTitle=\(itemEdit_itemTitle)&itemContent=\(itemEdit_itemContent)&itemPrice=\(itemEdit_itemprice)&address=\(itemEdit_address)&tag=\(itemEdit_tag)&itemCode=\(itemEdit_itemCode)"
        
        // 한글이 nil로 되지않도록 인코딩
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let url = URL(string: encodedStr)!
        
        let parameters = [
            "name": ""
        ]


        // 경로로부터 요청을 생성한다. 이 때 Content-Type 헤더 필드를 변경한다.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\"XXXXX\"",
                         forHTTPHeaderField: "Content-Type")
        
        // 파일URL로부터 multipart 데이터를 생성하고 업로드한다.
        if let data = itemEdit(with: filepath, parameters: parameters) {
            let task = URLSession.shared.uploadTask(with: request, from: data){ data, res, _ in
                completionHandler(data, res)
            }
            task.resume()
        }
    }
    
    func editTextOnly() -> Bool{
        var result: Bool = true
        let urlStr = "http://localhost:8080/bebeProject/ItemEditTextOnly_ios.jsp?category=\(itemEdit_category)&useAge=\(itemEdit_useage)&itemTitle=\(itemEdit_itemTitle)&itemContent=\(itemEdit_itemContent)&itemPrice=\(itemEdit_itemprice)&address=\(itemEdit_address)&tag=\(itemEdit_tag)&itemCode=\(itemEdit_itemCode)"
        print(urlStr)
        
        // 한글 url encoding
        urlPath = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        // Session과 URL 연결
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        // Task를 정의, Json의 전체를 가져오기 위함,
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil {
                print("Failed to update data")
                result = false
            }else {
                print("Data is updated")
                result = true
            }
        }
        task.resume() // task 실행
        return result // 입력이 잘되면 true, 안되면 false를 return
    }

}
