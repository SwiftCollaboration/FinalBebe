//
//  ItemEditViewController.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/03.
//

import UIKit
import STTextView // placeholder(textView) 기능
import IQKeyboardManagerSwift

// DB Model
var itemEdit_itemCode = ""
var itemEdit_category = ""
var itemEdit_useage = ""
var itemEdit_itemTitle = ""
var itemEdit_itemContent = ""
var itemEdit_itemimage = ""
var itemEdit_itemprice = ""
var itemEdit_usernickname = "" // ShareVar
var itemEdit_address = ""
var itemEdit_tag = ""
var itemEdit_user_email = "" // ShareVar

// Pickerview Data
var itemEdit_selectedCategory = "" // 선택한 picker Data (selectedCategory)
var itemEdit_selectedAge = "" // 선택한 picker Data (selectedAge)
var itemEdit_selectedLocation = "" // 선택한 picker Data (selectedLocation)

var itemEdit_pickerList = [["의류", "침구", "이유식", "목욕욕품"," 위생용품", "스킨케어", "외출용품", "완구"],
                  ["12개월", "24개월", "36개월"],
                  ["전체", "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]]


var itemEdit_searchItem = "" // 검색어 입력

class ItemEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let picker = UIImagePickerController() // 갤러리용
    var imageURL: URL?
    
    
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
        IQKeyboardManager.shared.enable = true
//        ItemEditViewController.delegate = self
//        ItemEditViewController.dataSource = self

        // 이미지추가 버튼
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
        
        
        
        //---------------------------------
        // Data 넣어주기
        //---------------------------------
        let url = URL(string: "http://localhost:8080/bebeProject/image/\(itemEdit_itemimage)")
        let data = try? Data(contentsOf: url!)
        imgView.image = UIImage(data: data!)
        
        tfItemTitle.text = "\(itemEdit_itemTitle)"
        btnCategory.setTitle(itemEdit_category, for: .normal)
        btnAge.setTitle(itemEdit_useage, for: .normal)
        tfItemPrice.text = "\(itemEdit_itemprice)"
        tfTag.text = "\(itemEdit_tag)"
        tvItemContent.text = "\(itemEdit_itemContent)"
        btnLocation.setTitle(itemEdit_address, for: .normal)
        
        // Do any additional setup after loading the view.
    }// viewDidLoad
    
    func receiveItems(itemCode: String, category: String, useage: String, itemTitle: String, itemContent: String, itemimage: String, itemprice: String, usernickname: String, address: String, tag: String, user_email: String){
        itemEdit_itemCode = itemCode
        itemEdit_category = category
        itemEdit_useage = useage
        itemEdit_itemTitle = itemTitle
        itemEdit_itemContent = itemContent
        itemEdit_itemimage = itemimage
        itemEdit_itemprice = itemprice
        itemEdit_usernickname = usernickname
        itemEdit_address = address
        itemEdit_tag = tag
        itemEdit_user_email = user_email
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // *** 위에 실행했던 View가 닫히고 다시 띄워질 때 ***
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    // 이미지 추가 버튼 Action
    @IBAction func btnImageAddAction(_ sender: UIButton) {
        if itemImageArray.count == 10{
            let alert = UIAlertController(title: "알림", message: "더 이상 이미지를 추가할 수 없습니다!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }else{
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    } // btnImageAddAction
    
    // 카테고리 선택 버튼
    @IBAction func btnCategoryAction(_ sender: UIButton) {
        let selectAlert = UIAlertController(title: "카테고리 선택", message: "상품에 맞는 카테고리를 선택하세요!\n\n\n\n\n\n", preferredStyle: .alert)
        // pickerView 추가
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 150))
        pickerView.tag = 0
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let leftAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let rightAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            // 실행할 내용
            // 카테고리 선택 버튼 Text 변경
            self.btnCategory.setTitle("\(itemEdit_selectedCategory)", for: .normal)
            
            // DB Model용 변수
            itemEdit_category = itemEdit_selectedCategory
        })
        
        selectAlert.addAction(leftAction)
        selectAlert.addAction(rightAction)
        selectAlert.view.addSubview(pickerView)
        
        present(selectAlert, animated: true, completion: nil)
    } // btnCategoryAction
    
    // 개월 수 버튼 액션
    @IBAction func btnAgeAction(_ sender: UIButton) {
        let selectAlert = UIAlertController(title: "개월 수 선택", message: "개월 수를 선택하세요!\n\n\n\n\n\n", preferredStyle: .alert)
        // pickerView 추가
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 150))
        pickerView.tag = 1
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let leftAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let rightAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            // 실행할 내용
            // 카테고리 선택 버튼 Text 변경
            self.btnAge.setTitle("\(itemEdit_selectedAge)", for: .normal)
            
            // DB Model용 변수
            itemEdit_useage = itemEdit_selectedAge
        })
        
        selectAlert.addAction(leftAction)
        selectAlert.addAction(rightAction)
        selectAlert.view.addSubview(pickerView)
        
        present(selectAlert, animated: true, completion: nil)
    } //btnAgeAction
    
    // 거래 희망 지역 선택
    @IBAction func btnLocationAction(_ sender: UIButton) {
        let selectAlert = UIAlertController(title: "거래 희망 지역 선택", message: "거래 희망 지역을 선택하세요!\n\n\n\n\n\n", preferredStyle: .alert)
        // pickerView 추가
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 150))
        pickerView.tag = 2
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let leftAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let rightAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            // 실행할 내용
            // 카테고리 선택 버튼 Text 변경
            self.btnLocation.setTitle("서울시 \(itemEdit_selectedLocation)", for: .normal)
        })
        
        selectAlert.addAction(leftAction)
        selectAlert.addAction(rightAction)
        selectAlert.view.addSubview(pickerView)
        
        present(selectAlert, animated: true, completion: nil)
    } // btnLocationAction
    
    
    // 수정 완료 버튼
    @IBAction func btnItemEditAction(_ sender: UIBarButtonItem) {
        itemEdit_itemTitle = (tfItemTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        itemcontent = tvItemContent.text!.replacingOccurrences(of: "\n", with: "\\n")
        itemEdit_itemprice = (tfItemPrice.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        itemEdit_address = "서울시 \(itemEdit_selectedLocation)".trimmingCharacters(in: .whitespacesAndNewlines)
        itemEdit_tag = tfTag.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 유효성 검사
        if itemEdit_itemTitle == ""{
            checkTextFieldAlert(item: "제목")
        }else if btnCategory.titleLabel?.text! == "카테고리"{
            checkSelectAlert(item: "카테고리")
        }else if btnAge.titleLabel?.text! == "개월 수"{
            checkSelectAlert(item: "개월 수")
        }else if itemEdit_itemprice == ""{
            checkTextFieldAlert(item: "원가")
        }else if itemEdit_tag == ""{
            checkTextFieldAlert(item: "태그")
        }else if itemEdit_itemContent == ""{
            checkTextFieldAlert(item: "게시글 내용")
        }else if btnLocation.titleLabel?.text! ==
                    "거래 희망 지역"{
            checkSelectAlert(item: "거래 희망 지역")
        }else if self.imageURL == nil{
            // DB에 입력 (이미지 제외)
            let itemEditModel = ItemEditModel()
            itemEditModel.editTextOnly()
            
            let resultAlert = UIAlertController(title: "완료", message: "수정이 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.changeSellerViewData()
                    self.dismiss(animated: true, completion: nil) // 이전 화면으로 이동
                    self.navigationController?.popViewController(animated: true)
                    
                })
            resultAlert.addAction(onAction) // 실행할 액션을 추가
            // Alert 띄우기
            present(resultAlert, animated: true, completion: nil)
            
            
        }else{
            // DB에 입력
            let itemEditModel = ItemEditModel()
            itemEditModel.uploadImageFile(at: self.imageURL!, completionHandler: {_,_ in print("Upload Success \(self.imageURL!)")})
            
            let resultAlert = UIAlertController(title: "완료", message: "수정이 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.changeSellerViewData_image() // 판매자 디테일뷰의 Data 변경
                    self.dismiss(animated: true, completion: nil) // 이전 화면으로 이동
                    self.navigationController?.popViewController(animated: true)
                    
                })
            resultAlert.addAction(onAction) // 실행할 액션을 추가
            // Alert 띄우기
            present(resultAlert, animated: true, completion: nil)
            
            
            }
    }// btnItemEditAction
    
    // 판매자 디테일뷰의 Data 변경(이미지 포함)
    func changeSellerViewData_image(){
        detailSeller_category = itemEdit_category
        detailSeller_useage = itemEdit_useage
        detailSeller_itemtitle = itemEdit_itemTitle
        detailSeller_itemcontent = itemEdit_itemContent
        detailSeller_itemimage = itemEdit_itemimage
        detailSeller_itemprice = itemEdit_itemprice
        detailSeller_address = itemEdit_address
        detailSeller_tag = itemEdit_tag
        
        print(detailSeller_category, detailSeller_useage, detailSeller_itemtitle, detailSeller_itemcontent, detailSeller_itemimage,
              detailSeller_itemprice, detailSeller_address, detailSeller_tag)
    }
    
    // 판매자 디테일뷰의 Data 변경(이미지 제외)
    func changeSellerViewData(){
        detailSeller_category = itemEdit_category
        detailSeller_useage = itemEdit_useage
        detailSeller_itemtitle = itemEdit_itemTitle
        detailSeller_itemcontent = itemEdit_itemContent
        detailSeller_itemprice = itemEdit_itemprice
        detailSeller_address = itemEdit_address
        detailSeller_tag = itemEdit_tag
        
        print(detailSeller_category, detailSeller_useage, detailSeller_itemtitle, detailSeller_itemcontent, detailSeller_itemimage,
              detailSeller_itemprice, detailSeller_address, detailSeller_tag)
    }
        
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
        return itemEdit_pickerList[tagNum].count
    }

    // picekrView 관련 Delegate
    // PickerView에 Title 입히기
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return itemEdit_pickerList[0][row]
            break
        case 1:
            return itemEdit_pickerList[1][row]
            break
        default:
            return itemEdit_pickerList[2][row]
            break
        }
        
    }

    // PickerView에 Data 선택
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            itemEdit_selectedCategory = "\(itemEdit_pickerList[0][row])"
            print("selectedCategory : \(itemEdit_selectedCategory)")
            break
        case 1:
            itemEdit_selectedAge = "\(itemEdit_pickerList[1][row])"
            print("selectedAge : \(itemEdit_selectedAge)")
            break
        default:
            itemEdit_selectedLocation = "\(itemEdit_pickerList[2][row])"
            print("selectedLocation : \(itemEdit_selectedLocation)")
            break
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // ItemEditViewController


// 갤러리 접근
extension ItemEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = image
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            print("imageURL is \(imageURL)")
        
        self.picker.dismiss(animated: true, completion: nil)
        }
    }
}
