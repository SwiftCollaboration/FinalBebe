//
//  MJViewController.swift
//  BabyProject
//
//  Created by hyogang on 2021/07/29.
//

import UIKit
var nick = "" , id = ""
class MJViewController: UIViewController {
    
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    var loginOnOff:Bool = true
    var loginfunc:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //mypage 함수 실행 -> delegate(extention) 실행 -> loginLogout함수 실행 -> 
        mypage(loginfunc: loginfunc)
    }
    
    @IBAction func buttonTest(_ sender: UIButton) {
    }
    @IBAction func buttonLogout(_ sender: UIButton) {
        loginOnOff = false
        loginLogout(login:loginOnOff)
    }
    
    //회원탈퇴 터치시 거래중인 항목 있는지 검사
    @IBAction func buttonWithdrawal(_ sender: UIButton) {
        if(MJLoginInfo.withdrawal == "true"){
            let alert = UIAlertController(title: "경고", message: "구매중, 판매중 아이템을\n정리 해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: .default) { (action) in }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //_______func__________________________________________________________
    
    
    //로그인하고 화면 / 로그아웃버튼 같이 작동하는 함수
    func loginLogout(login:Bool){
        if (login == true && loginfunc == false){
            mypage(loginfunc: true)
        }else if (login == false && loginfunc == true){
            MJLoginInfo.userNickName = ""
            MJLoginInfo.userEmail = ""
            mypage(loginfunc: false)
        }
    }
    
    // login DB 함수
    func mypage(loginfunc : Bool) {
        let mjSelectOfUserInfo = MJSelectOfUserInfo()
        mjSelectOfUserInfo.delegate = self
        mjSelectOfUserInfo.downloadItems()
        print(MJLoginInfo.userNickName)
        userNickname.text = "\(MJLoginInfo.userNickName) 님"
        userID.text = "\(MJLoginInfo.userEmail)"
        self.loginfunc = loginfunc
        
        let mjWithdrawalOfUserInfo = MJWithdrawalOfUserInfo()
        mjWithdrawalOfUserInfo.delegate = self
        mjWithdrawalOfUserInfo.downloadItems(userEmail: MJLoginInfo.userEmail)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MJViewController:MJSelectOfUserInfoProtocol{
    func itemDownloaded(items: NSArray) { //NSArray 배열중에 가장큰 배열이다.
        loginLogout(login:loginOnOff)
    }
}
