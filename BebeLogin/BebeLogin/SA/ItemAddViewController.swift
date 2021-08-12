//
//  ItemAddViewController.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/02.
//

import UIKit
import STTextView // placeholder(textView) 기능
import IQKeyboardManagerSwift

// DB Model
var category = ""
var useage = ""
var itemtitle = ""
var itemcontent = ""
var itemimage:UIImage?
var itemprice = ""
var usernickname = Share.userNickName
var address = ""
var tag = ""
var user_email = Share.userEmail

// Pickerview Data
var selectedCategory = "" // 선택한 picker Data (selectedCategory)
var selectedAge = "" // 선택한 picker Data (selectedAge)
var selectedLocation = "" // 선택한 picker Data (selectedLocation)

var pickerList = [["의류", "침구", "이유식", "목욕욕품"," 위생용품", "스킨케어", "외출용품", "완구"],
                  ["12개월", "24개월", "36개월"],
                  ["전체", "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]]

var itemImageArray: [UIImage] = [] // collectionViewCell용 변수
 

var searchItem = "" // 검색어 입력

class ItemAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let picker = UIImagePickerController() // 갤러리용
    var imageURL: URL?
    
    var restoreFrameValue: CGFloat = 0.0

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemAddCollectionView: UICollectionView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnAge: UIButton!
    @IBOutlet weak var btnSearchPrice: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var tfItemTitle: UITextField!
    @IBOutlet weak var tfItemPrice: UITextField!
    @IBOutlet weak var tfTag: UITextField!
    @IBOutlet weak var tvItemContent: STTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // extension으로 설정한 것을 실행
        picker.delegate = self
        itemAddCollectionView.delegate = self
        itemAddCollectionView.dataSource = self
        IQKeyboardManager.shared.enable = true

        print(Share.userEmail)
        
        // 이미지추가 버튼
        //btnAddImage.setTitle("\(itemImageArray.count)/10", for: .normal)
        btnAddImage.layer.cornerRadius = 10
        
        // 이미지 뷰
        imgView.layer.cornerRadius = 10

        // 카테고리 버튼
        btnCategory.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        btnCategory.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)

        // 개월 수 버튼
        btnAge.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        btnAge.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)

        // 원가 찾기 버튼
        btnSearchPrice.layer.cornerRadius = 10
        btnSearchPrice.isHidden = true
        
        // 제목 tf
        tfItemTitle.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        tfItemTitle.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        tfItemTitle.addLeftPadding()
        
        // 원가입력 & 찾아보기 버튼 label
        lblItemPrice.layer.addBorder([.top, .bottom], color: UIColor(named: "SubColor")!, width: 1)
        
        // 원가 입력 tf
        tfItemPrice.layer.addBorder([.top, .bottom], color: UIColor(named: "SubColor")!, width: 1)
        tfItemPrice.layer.addBorder([.left, .right], color: UIColor.white, width: 1)
        tfItemPrice.addLeftPadding()
        
        // 태그 입력 tf
        tfTag.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        tfTag.layer.addBorder([.left, .right, .bottom], color: UIColor.white, width: 1)
        tfTag.addLeftPadding()
        
        // 내용 입력 tv
        tvItemContent.layer.addBorder([.top, .bottom], color: UIColor(named: "SubColor")!, width: 1)
        tvItemContent.layer.addBorder([.left, .right], color: UIColor.white, width: 1)
        tvItemContent.textContainerInset = UIEdgeInsets(top: 15,left: 10,bottom: 0,right: 0)

        // Do any additional setup after loading the view.
    } // viewDidLoad
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // *** 위에 실행했던 View가 닫히고 다시 띄워질 때 ***
    override func viewWillAppear(_ animated: Bool) {
        // navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        IQKeyboardManager.shared.enable = true
        
        // 내용 초기화
        imgView.image = UIImage(named: "babyImage.png")
        tfItemTitle.text = ""
        btnCategory.setTitle("카테고리", for: .normal)
        btnAge.setTitle("개월 수", for: .normal)
        tfItemPrice.text = ""
        tfTag.text = ""
        tvItemContent.text = ""
        btnLocation.setTitle("거래 희망 지역", for: .normal)        
        
        //self.tabBarController?.tabBar.isHidden = false
        itemAddCollectionView.reloadData()
        
        //// 이미지추가 버튼
        //btnAddImage.setTitle("\(itemImageArray.count)/10", for: .normal)
    }
    
    // 이미지 추가 버튼 Action
    @IBAction func btnImageAddAction(_ sender: UIButton) {
        // 갤러리를 띄우기
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
        //-------------------------
        // 이전 CollectionView용 코드
        //-------------------------
//        if itemImageArray.count == 10{
//            let alert = UIAlertController(title: "알림", message: "더 이상 이미지를 추가할 수 없습니다!", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//            alert.addAction(alertAction)
//            present(alert, animated: true, completion: nil)
//        }else{
//            picker.sourceType = .photoLibrary
//            present(picker, animated: true, completion: nil)
//        }
    }
    
    
    // 카테고리 선택 Action
    @IBAction func btnCategoryAction(_ sender: UIButton) {
        let selectAlert = UIAlertController(title: "카테고리 선택", message: "상품에 맞는 카테고리를 선택하세요!\n\n\n\n\n\n", preferredStyle: .alert)
        // pickerView 추가
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 120))
        pickerView.tag = 0
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let leftAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let rightAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            // 실행할 내용
            // 카테고리 선택 버튼 Text 변경
            self.btnCategory.setTitle("\(selectedCategory)", for: .normal)
            
            // DB Model용 변수
            category = selectedCategory
        })
        
        selectAlert.addAction(leftAction)
        selectAlert.addAction(rightAction)
        selectAlert.view.addSubview(pickerView)
        
        present(selectAlert, animated: true, completion: nil)
    } // btnCategoryAction
    
    // 개월 수 버튼 Action
    @IBAction func btnAgeAction(_ sender: UIButton) {
        let selectAlert = UIAlertController(title: "개월 수 선택", message: "개월 수를 선택하세요!\n\n\n\n\n\n", preferredStyle: .alert)
        // pickerView 추가
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 120))
        pickerView.tag = 1
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let leftAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let rightAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            // 실행할 내용
            // 카테고리 선택 버튼 Text 변경
            self.btnAge.setTitle("\(selectedAge)", for: .normal)
            
            // DB Model용 변수
            useage = selectedAge
        })
        
        selectAlert.addAction(leftAction)
        selectAlert.addAction(rightAction)
        selectAlert.view.addSubview(pickerView)
        
        present(selectAlert, animated: true, completion: nil)
    } // btnAgeAction
    
    
    // 거래 희망 지역 선택
    @IBAction func btnLocationAction(_ sender: UIButton) {
        let selectAlert = UIAlertController(title: "거래 희망 지역 선택", message: "거래 희망 지역을 선택하세요!\n\n\n\n\n\n", preferredStyle: .alert)
        // pickerView 추가
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 120))
        pickerView.tag = 2
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let leftAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let rightAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            // 실행할 내용
            // 카테고리 선택 버튼 Text 변경
            self.btnLocation.setTitle("서울시 \(selectedLocation)", for: .normal)
        })
        
        selectAlert.addAction(leftAction)
        selectAlert.addAction(rightAction)
        selectAlert.view.addSubview(pickerView)
        
        present(selectAlert, animated: true, completion: nil)
    } // btnLocationAction
    
    
    
    // picekrView 관련 DataSource
    // picekrView의 컬럼 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // 출력할 데이터 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var tagNum = 0
        switch pickerView.tag {
        case 0:
            tagNum = 0
            break
        case 1:
            tagNum = 1
        default:
            tagNum = 2
            break
        }
        return pickerList[tagNum].count
    }

    // picekrView 관련 Delegate
    // PickerView에 Title 입히기
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return pickerList[0][row]
            break
        case 1:
            return pickerList[1][row]
            break
        default:
            return pickerList[2][row]
            break
        }
        
    }

    // PickerView에 Data 선택
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            selectedCategory = "\(pickerList[0][row])"
            print("selectedCategory : \(selectedCategory)")
            break
        case 1:
            selectedAge = "\(pickerList[1][row])"
            print("selectedAge : \(selectedAge)")
            break
        default:
            selectedLocation = "\(pickerList[2][row])"
            print("selectedLocation : \(selectedLocation)")
            break
        }
        
    }
    
    // 등록 버튼 Action
    
    @IBAction func barButtonAddAction(_ sender: UIBarButtonItem) {
        
        itemtitle = (tfItemTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        itemcontent = tvItemContent.text!.replacingOccurrences(of: "\n", with: "\\n")
        itemprice = tfItemPrice.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        address = "서울시 \(selectedLocation)".trimmingCharacters(in: .whitespacesAndNewlines)
        tag = tfTag.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("itemcontent is \(itemcontent)")
        
        
        
        
        // 유효성 검사
        if itemtitle == ""{
            checkTextFieldAlert(item: "제목")
        }else if btnCategory.titleLabel?.text! == "카테고리"{
            checkSelectAlert(item: "카테고리")
        }else if btnAge.titleLabel?.text! == "개월 수"{
            checkSelectAlert(item: "개월 수")
        }else if itemprice == ""{
            checkTextFieldAlert(item: "원가")
        }else if tag == ""{
            checkTextFieldAlert(item: "태그")
        }else if itemcontent == ""{
            checkTextFieldAlert(item: "게시글 내용")
        }else if btnLocation.titleLabel?.text! ==
                    "거래 희망 지역"{
            checkSelectAlert(item: "거래 희망 지역")
        }else if self.imageURL == nil{
            let alert = UIAlertController(title: "사진 선택", message: "사진을 선택해주세요!", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "알겠습니다", style: .default, handler: nil)
                
            alert.addAction(onAction)
                
            present(alert, animated: true, completion: nil)
            
        }else{
            // DB에 입력
            let itemInsertModel = ItemInsertModel()
            let result: () = itemInsertModel.uploadImageFile(at: imageURL!, completionHandler: {_,_ in print("Upload Success \(self.imageURL!)")})
            
            
            print("result is : \(result)")
            
            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: { [self]ACTION in
                    // 이동할 곳 넣기
                // 내용항목 비우기
                imgView.image = UIImage(named: "babyImage.png")
                tfItemTitle.text = ""
                btnCategory.setTitle("카테고리", for: .normal)
                btnAge.setTitle("개월 수", for: .normal)
                tfItemPrice.text = ""
                tfTag.text = ""
                tvItemContent.text = ""
                btnLocation.setTitle("거래 희망 지역", for: .normal)
                
                
                })
            resultAlert.addAction(onAction) // 실행할 액션을 추가
            // Alert 띄우기
            present(resultAlert, animated: true, completion: nil)
            
        }
    }// barButtonAddAction
    
    // 버튼 선택 항목을 확인하세요 Alert
    func checkSelectAlert(item: String) {
        let alert = UIAlertController(title: "\(item) 선택", message: "\(item)을 선택해주세요!", preferredStyle: .alert)
        let onAction = UIAlertAction(title: "알겠습니다", style: .default, handler: nil)
        
        alert.addAction(onAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 텍스트필드 항목을 확인하세요 Alert
    func checkTextFieldAlert(item: String) {
        let alert = UIAlertController(title: "\(item) 확인", message: "\(item)을 입력해주세요!", preferredStyle: .alert)
        let onAction = UIAlertAction(title: "알겠습니다", style: .default, handler: nil)
        
        alert.addAction(onAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
} // ItemAddViewController

// 테두리 상하좌우만 추가하기
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width + 1000, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width + 1000, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
        /*
         UIRectEdge.all, //전체
         UIRectEdge.top, //상단
         UIRectEdge.bottom, //하단
         UIRectEdge.left, //왼쪽
         UIRectEdge.right, //오른쪽
         */
    }
} // extension CALayer

// TextField 왼쪽 들여쓰기
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
} // extension UITextField

//UICollectionView의 모양, 기능 설정
extension ItemAddViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    // cell의 갯수 return
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImageArray.count
    }
    
    // cell 구성(색깔 등)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Identifier가 itemImageAddcell에 해당하는 cell에
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageAddCollectionViewCell", for: indexPath) as! ItemImageAddCollectionViewCell
        // as! UICollectionViewCell는 Type 변환
        
        
        cell.itemAddImageView.image = itemImageArray[indexPath.row]
        cell.backgroundColor = .lightGray // UIColor 생략하여 씀
        cell.btnItemImageRemove.layer.setValue(indexPath.row, forKey: "index")
        cell.btnItemImageRemove.addTarget(self, action: "deleteUser:", for: UIControl.Event.touchUpInside)
        

        return cell
        
    }
}


// Cell Layout 정의
extension ItemAddViewController: UICollectionViewDelegateFlowLayout{
    
    // 위 아래 간격 minimumLineSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 옆 간격 minimumInteritemSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell 사이즈 (옆 라인을 고려하여 설정) sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 100)
        
        return size
    }
    
}

// 갤러리 접근
extension ItemAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = image
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            
//            // -------------------------
//            // 이전 collectionView용 소스
//            // -------------------------
//            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                itemImageArray.append(image)
//                imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
//                print("itemImageArray is \(itemImageArray)")
//            // 이미지추가 버튼
//            btnAddImage.setTitle("\(itemImageArray.count)/10", for: .normal)
//            self.itemAddCollectionView.reloadData()
        }
        
        self.picker.dismiss(animated: true, completion: nil)
    }
}





/*
 MIT License

 Copyright (c) 2020 Tamerlan Satualdypov

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


