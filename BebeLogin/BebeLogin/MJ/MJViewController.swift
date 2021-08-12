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
        // navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //mypage 함수 실행 -> delegate(extention) 실행 -> loginLogout함수 실행 ->
        mypage(loginfunc: loginfunc)
    }
    
    @IBAction func buttonTest(_ sender: UIButton) {
    }
    @IBAction func buttonLogout(_ sender: UIButton) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
                let no = UIAlertAction(title: "취소", style: .default, handler: nil)
                let yes = UIAlertAction(title: "확인", style: .destructive, handler: {ACTION in self.logout()})
                alert.addAction(no)
                alert.addAction(yes)
                
                present(alert, animated: true, completion: nil)
    }
    
    //상점보기
    @IBAction func buttonShop(_ sender: UIButton) {
        MJShopOfSelect.userEmail = Share.userEmail
        let mjMyShopPage = MJMyShopPage()
        mjMyShopPage.delegate = self
        mjMyShopPage.downloadItems()
    }
    //회원탈퇴 터치시 거래중인 항목 있는지 검사
    @IBAction func buttonWithdrawal(_ sender: UIButton) {
        if(Share.withdrawal == "true"){
            let alert = UIAlertController(title: "경고", message: "구매중, 판매중 아이템을\n정리 해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: .default) { (action) in }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    // ============== 이도희 ==============
    // mypage -> chat
    @IBAction func btnChat(_ sender: UIButton) {
        tabBarController?.selectedIndex = 3
    }
    // ============== 이도희 ==============
    
    
    
    //_______func__________________________________________________________
//
//
    //로그인하고 화면 / 로그아웃버튼 같이 작동하는 함수
    func loginLogout(login:Bool){
        if (login == true && loginfunc == false){
            mypage(loginfunc: true)
        }else if (login == false && loginfunc == true){
            Share.userNickName = ""
            Share.userEmail = ""
            mypage(loginfunc: false)
            let alert = UIAlertController(title:"로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
            let no = UIAlertAction(title: "취소", style: .default, handler: nil)
            let yes = UIAlertAction(title: "확인", style: .destructive, handler: {ACTION in self.logout()})
            alert.addAction(no)
            alert.addAction(yes)

            present(alert, animated: true, completion: nil)
        }
    }
    
    // login DB 함수
    func mypage(loginfunc : Bool) {
        let mjSelectOfUserInfo = MJSelectOfUserInfo()
        mjSelectOfUserInfo.delegate = self
        mjSelectOfUserInfo.downloadItems()
        userNickname.text = "\(Share.userNickName) 님"
        userID.text = "\(Share.userEmail)"
        self.loginfunc = loginfunc
        
        let mjWithdrawalOfUserInfo = MJWithdrawalOfUserInfo()
        mjWithdrawalOfUserInfo.delegate = self
        mjWithdrawalOfUserInfo.downloadItems(userEmail: Share.userEmail)
    }
    
    //로그아웃함수
    func logout(){
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "nickname")
        let model = LogoutModel()
        model.selectLoginType(email: Share.userEmail)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login")
        loginVC?.modalPresentationStyle = .fullScreen
                        self.present(loginVC!, animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: false)
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

