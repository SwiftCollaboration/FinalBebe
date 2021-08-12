//
//  MJMyShopViewController.swift
//  BebeLogin
//
//  Created by 김민재 on 2021/08/10.
//

import UIKit

class MJMyShopViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView! //평점 바
    @IBOutlet weak var labelUserNickName: UILabel! // 닉네임레이블
    @IBOutlet weak var labelUserEmail: UILabel! // 이메일레이블
    @IBOutlet weak var labelUserScore: UILabel! // 평점레이블
    @IBOutlet weak var labelUserSignDate: UILabel! // 가입날짜레이블
    
    
    var loginOnOff:Bool = true
    var loginfunc:Bool = false
    var selectUserShop = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 8)
        
        selectUserShop = 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let mjMyShopPage = MJMyShopPage()
        mjMyShopPage.delegate = self
        mjMyShopPage.downloadItems()
        
        print(1)
        //mypage 함수 실행 -> delegate(extention) 실행 -> loginLogout함수 실행 ->
        progressView.progress += Float(MJShopOfSelect.score)/200
        labelUserNickName.text = "\(MJShopOfSelect.userNickName) 님"
        labelUserEmail.text = MJShopOfSelect.userEmail
        labelUserScore.text = "\(100+Float(MJShopOfSelect.score)) 점"
        labelUserSignDate.text = "\(MJShopOfSelect.userSignUpDate)"
    }
    
    //_______func__________________________________________________________
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension MJMyShopViewController:MJSelectOfUserInfoProtocol{
    func itemDownloaded(items: NSArray) { //NSArray 배열중에 가장큰 배열이다.
        if (selectUserShop == 0){
            viewWillAppear(true)
            selectUserShop=1
        }
    }
}

