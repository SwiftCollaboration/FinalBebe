//
//  ChatViewController.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import UIKit

var chatMessageItem: NSArray = NSArray()

var receiveRoomcode = ""
var receiveItemcode = ""
var receiveItemtitle = ""
var receiveItemimage = ""
var receiveNickname = ""
var receiveScoreType = ""
var receiveSellerEmail = ""
var receiveBuyerEmail = ""
var receiveScoreEmail = ""

let interval = 3.0  // 1초
let timeSelector: Selector = #selector(ChatViewController.updateTime)

var now = ""
var set = ""

class ChatViewController: UIViewController {

    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var cvChat: UICollectionView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var lblItemTitle: UILabel!
    @IBOutlet weak var vTvBackgroundWhite: UIView!
    @IBOutlet weak var vTvBackgroundGray: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cvChat.delegate = self
        cvChat.dataSource = self
        
        btnReview.layer.cornerRadius = 10
        vTvBackgroundWhite.layer.cornerRadius = 20
        
        // 1초마다 한번씩 업데이트 되어 메세지 실시간 주고 받기
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        
        
        // 채팅 거래 중인 아이템 이미지, 제목
        let url = URL(string: share.imgUrl(receiveItemimage))
        let data = try? Data(contentsOf: url!)
        imgViewItem.image = UIImage(data: data!)
    
        lblItemTitle.text = receiveItemtitle
        
        // 키보드 올렸다 내렸다
        setKeybaordEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let chatMessageSelectModel = ChatMessageSelectModel()
        chatMessageSelectModel.delegate = self
        chatMessageSelectModel.chatMessageSelectItems(receiveRoomcode)
        
        cvChat.reloadData()
        
        // 채팅 상단 타이틀을 상대 닉네임으로 설정
        self.navigationItem.title = receiveNickname
    }
    
    // 키보드 올렸다 내렸다할 때 문자 입력 위치 변경
    func setKeybaordEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisAppear(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 올라왔을 때 문자 입력 올리기
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        self.vTvBackgroundGray.frame.origin.y = 485
    }
    
    // 키보드 내려왔을 때 문자 입력 내리기
    @objc func keyboardWillDisAppear(_ sender: NotificationCenter){
        self.vTvBackgroundGray.frame.origin.y = 0
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        let message = tfMessage.text
        
        if tfMessage.text?.count != 0 {
            let chatInsertModel = ChatInsertModel()
            let result = chatInsertModel.insertItems(message!, Share.userEmail, receiveRoomcode)
            
            if result {
                tfMessage.text?.removeAll()
            }else {
                let resultAlert = UIAlertController(title: "Error", message: "에러가 발생 되었습니다", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnReview(_ sender: UIButton) {
        var reviewScore = 0
        
        let resultAlert = UIAlertController(title: "후기", message: "거래에 대한 후기를 남겨주세요!", preferredStyle: .alert)
        let score1 = UIAlertAction(title: "🥰", style: .default, handler: {Action in
            reviewScore = 2
            self.insertReview(reviewScore)
        })
        let score2 = UIAlertAction(title: "😀", style: .default, handler: {Action in
            reviewScore = 1
            self.insertReview(reviewScore)
        })
        let score3 = UIAlertAction(title: "😐", style: .default, handler: {Action in
            reviewScore = 0
            self.insertReview(reviewScore)
        })
        let score4 = UIAlertAction(title: "🤬", style: .default, handler: {Action in
            reviewScore = -1
            self.insertReview(reviewScore)
        })
        let score5 = UIAlertAction(title: "😟", style: .default, handler: {Action in
            reviewScore = -2
            self.insertReview(reviewScore)
        })
        
        resultAlert.addAction(score1)
        resultAlert.addAction(score2)
        resultAlert.addAction(score3)
        resultAlert.addAction(score4)
        resultAlert.addAction(score5)
        present(resultAlert, animated: true, completion: nil)
    }
    
    func insertReview(_ reviewScore: Int) {
        let reviewInsertModel = ReviewInsertModel()
        reviewInsertModel.delegate = self
        reviewInsertModel.reviewInsertItems(receiveItemcode, reviewScore, receiveScoreType, receiveSellerEmail, receiveBuyerEmail, receiveScoreEmail)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func receiveItems(_ roomcode: String, _ itemcode: String, _ itemtitle: String, _ itemimage: String, _ nickname: String, _ scoreType: String, _ sellerEmail: String, _ buyerEmail: String, _ scoreEmail: String) {
        receiveRoomcode = roomcode
        receiveItemcode = itemcode
        receiveItemtitle = itemtitle
        receiveItemimage = itemimage
        receiveNickname = nickname
        receiveScoreType = scoreType
        receiveSellerEmail = sellerEmail
        receiveBuyerEmail = buyerEmail
        receiveScoreEmail = scoreEmail
    }
    
    // 빈 공간 누르면 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 1초마다 화면 다시 불러오기
    @objc func updateTime() {
        viewWillAppear(true)
    }
}

// 메세지 내용 JSP로 가져오기
extension ChatViewController: ChatMessageSelectModelProtocol {
    func itemDeownloaded(items: NSArray) {
        chatMessageItem = items
        self.cvChat.reloadData()
    }
}

// 후기 입력했었는지 체크해서 입력
extension ChatViewController: ReviewInsertModelProtocol {
    func itemDeownloaded(items: NSArray) {
        var result = items
        
        if result == "alreadyExists" {
            let resultAlert = UIAlertController(title: "안내", message: "이미 입력된 후기입니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }else {
            let resultAlert = UIAlertController(title: "완료", message: "후기가 입력 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    }
}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatMessageItem.count
    }
    
    // cell 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! ChatCollectionViewCell
        
        let item: ChatMessageDBModel = chatMessageItem[indexPath.row] as! ChatMessageDBModel
        
        // 내 채팅인 경우, 상대 채팅인 경우에 따른 설정
        if item.user_email == Share.userEmail {
            // 배경색 설정
            cell.cvMessage.backgroundColor = nil
//            cell.cvMessage.backgroundColor = UIColor(named: "SubColor")
            // 왼오 정렬
            cell.containerViewRightTestAnchor?.isActive = true
            cell.containerViewRightAnchor?.isActive = false
            cell.containerViewLeftAnchor?.isActive = false
            cell.lblMessage.textAlignment = .right
        }else {
            // 배경색 설정
            cell.cvMessage.backgroundColor = .lightGray
            // 왼오 정렬
            cell.containerViewRightTestAnchor?.isActive = false
            cell.containerViewLeftAnchor?.isActive = true
            cell.lblMessage.textAlignment = .left
        }

        cell.lblMessage.text = "\(item.message!)"
        cell.lblDate.text = "\(item.senddate!)"
        
        if (item.message?.count)! > 0 {
            cell.containerViewWidthAnchor?.constant = measuredFrameHeightForEachMessage(item.message!).width
        }
        
        return cell
    }
    
    private func measuredFrameHeightForEachMessage(_ message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
