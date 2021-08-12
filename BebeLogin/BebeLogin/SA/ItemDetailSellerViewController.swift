//
//  ItemDetailSellerViewController.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/03.
//

import UIKit

// DB Model
var detailSeller_category = ""
var detailSeller_useage = ""
var detailSeller_itemtitle = ""
var detailSeller_itemcontent = ""
var detailSeller_itemimage = ""
var detailSeller_itemprice = ""
var detailSeller_usernickname = ""
var detailSeller_address = ""
var detailSeller_tag = ""
var detailSeller_dealCompleteDate = ""
var detailSeller_deleteDate = ""
var detailSeller_user_email = ""

// 쉼표단위로 내역을 꺼내서 array에 추가
var detailSeller_tagArray: [String] = detailSeller_tag.components(separatedBy: ",")

class ItemDetailSellerViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategoryAgePrice: UILabel! // 통합 라벨
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblUseAge: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var btnTradeStatus: UIButton! // 거래중, 거래완료
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnItemEditDelete: UIButton!
    
    var feedItem: NSMutableArray = NSMutableArray() // 배열 생성, NSArray는 한번 생성되면 값을 바꿀 수 없음
    var itemCode = "9" // ********receiveItem으로 받아올 것**********

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queryModel = ItemDetailQueryModel() // 생성자 생성
        
        // extension으로 정의한 것을 실행
        queryModel.delegate = self
        queryModel.downloadItems(itemCode: itemCode)
        
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.delegate = self
        
        // 닉네임 라벨
        lblNickname.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        lblNickname.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        lblNickname.font = UIFont.boldSystemFont(ofSize: 25)
        
        // 제목 라벨
        lblTitle.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        lblTitle.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        lblTitle.font = UIFont.boldSystemFont(ofSize: 25)
        
        // lblCategoryAgePrice 라벨
        lblCategoryAgePrice.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        lblCategoryAgePrice.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        
        // 개월 수 라벨
        lblUseAge.clipsToBounds = true
        lblUseAge.layer.cornerRadius = 10
        
        // tagCollectionView
        tagCollectionView.layer.addBorder([.top, .bottom], color: UIColor(named: "SubColor")!, width: 1)
        tagCollectionView.layer.addBorder([.left, .right], color: UIColor.white, width: 1)
        
        // tvContent (TextView)
        tvContent.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        tvContent.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        
        // 거래 상태 버튼
        btnTradeStatus.layer.cornerRadius = 10
        
        // 수정/삭제 버튼
        btnItemEditDelete.layer.cornerRadius = 10
        
        
        // Do any additional setup after loading the view.
    } // viewDidLoad
    
    // 셀 클릭시 셀에 해당하는 내용 가져오기
    func receiveItems(_ itemcode: String){
        itemCode = itemcode
    }
    
    // *** 위에 실행했던 View가 닫히고 다시 띄워질 때 ***
    override func viewWillAppear(_ animated: Bool) {
        
        lblNickname.text = "\(detailSeller_usernickname)\t\t"
        lblTitle.text = "  \(detailSeller_itemtitle)"
        lblCategory.text = "  \(detailSeller_category)"
        lblUseAge.text = "  \(detailSeller_useage)"
        lblLocation.text = "\(detailSeller_address)"
        
        
        tagCollectionView.reloadData()
    }
    
    // QueryModel로 불러온 데이터를 전역변수에 넣기
    func itemsToVariable(){
        let item: ItemDBModel = feedItem[0] as! ItemDBModel
        
        detailSeller_category = item.category!
        detailSeller_useage = item.useAge!
        detailSeller_itemtitle = item.itemTitle!
        detailSeller_itemcontent = item.itemContent!
        detailSeller_itemimage = item.itemImage!
        detailSeller_itemprice = item.itemPrice!
        detailSeller_usernickname = item.userNickname!
        detailSeller_address = item.address!
        detailSeller_tag = item.tag!
        detailSeller_dealCompleteDate = item.dealCompleteDate!
        detailSeller_deleteDate = item.deleteDate!
        detailSeller_user_email = item.user_email!
        
    }
    
    
    // 거래 상태 변경
    @IBAction func btnTradeStatusAction(_ sender: UIButton) {
    }
    
    
    // 수정/삭제 버튼 액션
    @IBAction func btnItemEditDeleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "수정 / 삭제", message: nil, preferredStyle: .actionSheet)
        let actionDefault = UIAlertAction(title: "수정", style: .default, handler: {ACTION in
            // 실행할 내용
            self.performSegue(withIdentifier: "sgItemEdit", sender: self)
        })
        let actionDestructive = UIAlertAction(title: "삭제", style: .destructive, handler: {ACTION in
            // 실행할 내용
            print("상품 삭제 실행")
            let deleteModel = ItemDeleteModel()
            let result = deleteModel.deleteItems(itemCode: self.itemCode)
            
            // 삭제(deleteDate)가 잘되었는 지 안되었는 지 확인
            if result{
                let resultAlert = UIAlertController(title: "완료", message: "삭제가 완료 되었습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                resultAlert.addAction(onAction) // 실행할 액션을 추가
                // Alert 띄우기
                self.present(resultAlert, animated: true, completion: nil)
            }else{
                let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                resultAlert.addAction(onAction) // 실행할 액션을 추가
                // Alert 띄우기
                self.present(resultAlert, animated: true, completion: nil)
            }
        })
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: {ACTION in
            // 실행할 내용
        })
                
        // Controller와 Action결합
        alert.addAction(actionDefault) //
        alert.addAction(actionDestructive) // 실행할 내용
        alert.addAction(actionCancel) //
                
        // 화면 띄우기
        present(alert, animated: true, completion: nil)
    }
    
    // 천단위 숫자 콤마 찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // 클릭한 셀의 정보 가져오기
        // segue 이름이 "sgDetail"이면
        if segue.identifier == "sgItemEdit"{
            let detailView = segue.destination as! ItemEditViewController // sender를 이용해서 ItemEditViewController과 연결
                    
            // indexPath의 Data를 가져옴
            detailView.receiveItems(itemCode: itemCode, category: detailSeller_category, useage: detailSeller_useage, itemTitle: detailSeller_itemtitle, itemContent: detailSeller_itemcontent, itemimage: detailSeller_itemimage, itemprice: detailSeller_itemprice, usernickname: detailSeller_usernickname, address: detailSeller_address, tag: detailSeller_tag, user_email: detailSeller_user_email)
        }
    }
    

} // ItemDetailSellerViewController


//UICollectionView의 모양, 기능 설정
extension ItemDetailSellerViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    // cell의 갯수 return
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailSeller_tagArray.count
    }
    
    // cell 구성(색깔 등)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Identifier가 myCell에 해당하는 cell에
        let cell = self.tagCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailSellerCollectionViewCell", for: indexPath) as! ItemDetailSellerCollectionViewCell
        // as! UICollectionViewCell는 Type 변환
        print(detailSeller_tagArray)
        
        cell.lblTag.text = detailSeller_tagArray[indexPath.row] // lblTag Data를 입력
        cell.lblTag.layer.cornerRadius = 5
        cell.lblTag.backgroundColor = UIColor(named: "SubColor")
        return cell
        
    }
}


// Cell Layout 정의
extension ItemDetailSellerViewController: UICollectionViewDelegateFlowLayout{
    
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
        let width = tagCollectionView.frame.width / 4 - 1
        let size = CGSize(width: width, height: tagCollectionView.frame.height)
        
        return size
    }
    
}

// ItemDBModel에 설정한 Protocol 사용
extension ItemDetailSellerViewController: ItemDetailQueryModelProtocol{
    func itemDownloaded(items: NSMutableArray) {
        feedItem = items
        itemsToVariable() // 전역변수 DBModel 값 넣기
        
        //---------------------------------
        // Data 넣어주기
        //---------------------------------
        let url = URL(string: "http://localhost:8080/bebeProject/image/\(detailSeller_itemimage)")
        let data = try? Data(contentsOf: url!)
        print("data is \(data)")
        imgView.image = UIImage(data: data!)
        
        if detailSeller_dealCompleteDate == "null"{
            btnTradeStatus.setTitle("판매 중", for: .normal)
        }
        
        let itemPrice = numberFormatter(number: Int(detailSeller_itemprice)!)
        
        lblNickname.text = "\(detailSeller_usernickname)\t\t"
        lblTitle.text = "  \(detailSeller_itemtitle)"
        lblCategory.text = "\(detailSeller_category)"
        lblUseAge.text = "\(detailSeller_useage)"
        lblCategoryAgePrice.text = "\(itemPrice)원\t\t"
        tvContent.text = detailSeller_itemcontent
        lblLocation.text = "\(detailSeller_address)"
        
        // 태그 데이터 구성
        detailSeller_tagArray = detailSeller_tag.components(separatedBy: ",")
        
        tagCollectionView.reloadData()
    }
}
