//
//  ItemDetailBuyerViewController.swift
//  BabyProject
//
//  Created by Seong A Oh on 2021/08/03.
//

import UIKit

// DB Model
var detailBuyer_category = ""
var detailBuyer_useage = ""
var detailBuyer_itemtitle = ""
var detailBuyer_itemcontent = ""
var detailBuyer_itemimage = ""
var detailBuyer_itemprice = ""
var detailBuyer_usernickname = ""
var detailBuyer_address = ""
var detailBuyer_tag = ""
var detailBuyer_dealCompleteDate = ""
var detailBuyer_deleteDate = ""
var detailBuyer_user_email = ""

var detailBuyer_tagArray: [String] = []

var itemCode = "" // ********receiveItem으로 받아올 것

// ================== 이도희 ==================
var checkRoom = ""
// ================== 이도희 ==================

class ItemDetailBuyerViewController: UIViewController {
    @IBOutlet weak var btnTradeStatus: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategoryAgePrice: UILabel! // 통합 라벨
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblUseAge: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    
    var feedItem: NSMutableArray = NSMutableArray() // 배열 생성, NSArray는 한번 생성되면 값을 바꿀 수 없음
    
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
        tagCollectionView.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        tagCollectionView.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        
        // tvContent (TextView)
        tvContent.layer.addBorder([.top], color: UIColor(named: "SubColor")!, width: 1)
        tvContent.layer.addBorder([.bottom, .left, .right], color: UIColor.white, width: 1)
        tvContent.textAlignment = NSTextAlignment.left
        
        // 거래 상태 버튼
        btnTradeStatus.layer.cornerRadius = 10
        
        // 채팅하기 버튼
        btnChat.layer.cornerRadius = 10
        

        
        // Do any additional setup after loading the view.
    } // viewDidLoad
    
    // 셀 클릭시 셀에 해당하는 내용 가져오기
    func receiveItems(_ itemcode: String){
        itemCode = itemcode
        print("Ch 에서 SA 아이템 코드값: \(itemcode)")
    }
    
    
    
    // 화면이 내려가있다가 다시 팝업될 때 실행
    override func viewWillAppear(_ animated: Bool) {
//        let queryModel = ItemDetailQueryModel() // 생성자 생성
//
//        // extension으로 정의한 것을 실행
//        queryModel.delegate = self
//        queryModel.downloadItems(itemCode: itemCode)
//        itemsToVariable() // 전역변수에 DBModel 값 넣기
    }
    
    // QueryModel로 불러온 데이터를 전역변수에 넣기
    func itemsToVariable(){
        let item: ItemDBModel = feedItem[0] as! ItemDBModel
        
        detailBuyer_category = item.category!
        detailBuyer_useage = item.useAge!
        detailBuyer_itemtitle = item.itemTitle!
        detailBuyer_itemcontent = item.itemContent!
        detailBuyer_itemimage = item.itemImage!
        detailBuyer_itemprice = item.itemPrice!
        detailBuyer_usernickname = item.userNickname!
        detailBuyer_address = item.address!
        detailBuyer_tag = item.tag!
        detailBuyer_dealCompleteDate = item.dealCompleteDate!
        detailBuyer_deleteDate = item.deleteDate!
        detailBuyer_user_email = item.user_email!
        
        print("item.itemContent is \(item.itemContent!)")
    }
    
    // 천단위 숫자 콤마 찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // ================== 이도희 ==================
    //***************************
    //********채팅하기 버튼*********
    //***************************
    @IBAction func btnChatAction(_ sender: UIButton) {
        let chatRoomCheckModel = ChatRoomCheckModel()
        chatRoomCheckModel.delegate = self
        chatRoomCheckModel.chatRoomCheckItems(detailBuyer_user_email, Share.userEmail, itemCode)
    }
    // ================== 이도희 ==================
    // ================== 김민재 ==================
    //***************************
    //********해당상점보기 버튼*********
    //***************************
    @IBAction func buttonYourShop(_ sender: UIButton) {
            MJShopOfSelect.userEmail = detailBuyer_user_email
            let mjMyShopPage = MJMyShopPage()
            mjMyShopPage.delegate = self
            mjMyShopPage.downloadItems()
    }
    // ================== 김민재 ==================
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//        // 클릭한 상품의 정보 가져오기
//        // segue 이름이 "sgDetail"이면
//        if segue.identifier == "**segue명**"{
//            let detailView = segue.destination as! **컨트롤러명** // sender를 이용해서 컨트롤러와 연결
//
//            // indexPath의 Data를 가져옴
//            // 필요하신것만 가져가시면 됩니다~
//            detailView.receiveItems(itemCode: itemCode, category: detailSeller_category, useage: detailSeller_useage, itemTitle: detailSeller_itemtitle, itemContent: detailSeller_itemcontent, itemimage: detailSeller_itemimage, itemprice: detailSeller_itemprice, usernickname: detailSeller_usernickname, address: detailSeller_address, tag: detailSeller_tag, user_email: detailSeller_user_email)
//        }
        
    }
    

} // ItemDetailBuyerViewController


//UICollectionView의 모양, 기능 설정
extension ItemDetailBuyerViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    // cell의 갯수 return
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailBuyer_tagArray.count
    }
    
    // cell 구성(색깔 등)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Identifier가 myCell에 해당하는 cell에
        let cell = self.tagCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailBuyerCollectionViewCell", for: indexPath) as! ItemDetailBuyerCollectionViewCell
        // as! UICollectionViewCell는 Type 변환
        print(detailBuyer_tagArray)
        
        cell.lblTag.text = detailBuyer_tagArray[indexPath.row] // lblTag Data를 입력
        cell.lblTag.layer.cornerRadius = 5
        cell.lblTag.backgroundColor = UIColor(named: "SubColor")
        return cell
        
    }
}


// Cell Layout 정의
extension ItemDetailBuyerViewController: UICollectionViewDelegateFlowLayout{
    
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
extension ItemDetailBuyerViewController: ItemDetailQueryModelProtocol{
    func itemDownloaded(items: NSMutableArray) {
        feedItem = items
        itemsToVariable() // 전역변수 DBModel 값 넣기
        //print("feedItem is \(feedItem)")
        print("itemcode is \(itemCode)")
        print("detailBuyer_tag is \(detailBuyer_tag)")
        
        
        //---------------------------------
        // Data 넣어주기
        //---------------------------------
        let url = URL(string: "http://localhost:8080/bebeProject/image/\(detailBuyer_itemimage)")
        let data = try? Data(contentsOf: url!)
        imgView.image = UIImage(data: data!)
        
        if detailBuyer_dealCompleteDate == "null"{
            btnTradeStatus.setTitle("판매 중", for: .normal)
        }
        
        let itemPrice = numberFormatter(number: Int(detailBuyer_itemprice)!)
        
        lblNickname.text = "\(detailBuyer_usernickname)\t\t"
        lblTitle.text = "  \(detailBuyer_itemtitle)"
        lblCategory.text = "\(detailBuyer_category)"
        lblUseAge.text = "\(detailBuyer_useage)"
        lblCategoryAgePrice.text = "\(itemPrice)원\t\t"
        tvContent.text = detailBuyer_itemcontent
        lblLocation.text = "\(detailBuyer_address)"
        
        
        // 태그 데이터 구성
        detailBuyer_tagArray = detailBuyer_tag.components(separatedBy: ",")
        print("detailBuyerArray is \(detailBuyer_tagArray)")
        
        tagCollectionView.reloadData()
    }
}

// ================== 이도희 ==================
// 채팅하기 버튼 클릭 시 채팅방 입장 체크
extension ItemDetailBuyerViewController: ChatRoomCheckModelProtocol {
    func itemDeownloaded(items: String) {
        checkRoom = items
        
        let chatView = ChatViewController()
        chatView.receiveItems(checkRoom, itemCode, detailBuyer_itemtitle, detailBuyer_itemimage, detailBuyer_usernickname, "sellerscore", detailBuyer_user_email, Share.userEmail, detailBuyer_user_email)
    }
}
// ================== 이도희 ==================

// ================== 김민재 ==================
// 채팅하기 버튼 클릭 시 채팅방 입장 체크
extension ItemDetailBuyerViewController: MJSelectOfUserInfoProtocol {
    func itemDownloaded(items: NSArray) {
    }
}
// ================== 이도희 ==================
