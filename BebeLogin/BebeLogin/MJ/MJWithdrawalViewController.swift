//
//  MJWithdrawalViewController.swift
//  BabyProject
//
//  Created by 김민재 on 2021/08/05.
//

import UIKit

class MJWithdrawalViewController: UIViewController {
    
    @IBOutlet weak var textFieldPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textFieldPassword.addTarget(self, action: #selector(textFieldDidChange(textField:)) , for: UIControl.Event.editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        let mJWithdrawalAndPasswordTrueFalse = MJWithdrawalAndPasswordTrueFalse()
        mJWithdrawalAndPasswordTrueFalse.delegate = self
        mJWithdrawalAndPasswordTrueFalse.downloadItems(trueFalseOfPassword: textFieldPassword.text!)
    }
    
    
    @IBAction func buttonWithdrawal(_ sender: UIButton) {
        if(Share.trueFalseOfPassword == "true"){
            let withdrawalAlert = UIAlertController(title: "경고", message: "에구...😭정말 탈퇴 하실건가요? \n탈퇴시 가입된 정보는 삭제 됩니다🥺...", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { ACTION in self.realWithdrawal() })
            let noAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default, handler: nil)
            withdrawalAlert.addAction(yesAction)
            withdrawalAlert.addAction(noAction)
            present(withdrawalAlert, animated: true, completion: nil)
        } else if (Share.trueFalseOfPassword == "false"){
            let withdrawalAlert = UIAlertController(title: "비밀번호를 확인해 주세요.", message: "에구...😭정말 탈퇴 하실건가요? \n탈퇴시 가입된 정보는 삭제 됩니다🥺...", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: {ACTION in })
            withdrawalAlert.addAction(yesAction)
            present(withdrawalAlert, animated: true, completion: nil)
        }
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        viewWillAppear(true)
    }
    
    func realWithdrawal() {
        let mJRealWithdrawal = MJRealWithdrawal()
        let result = mJRealWithdrawal.userUpdate()
        print("result :",result)
        if result{
            let resultAlert = UIAlertController(title: "회원 탈퇴 완료...😥", message: "회원 탈퇴 되었습니다.\n로그인 페이지로 이동합니다...\n그동안 감사했습니다.\n😣", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "네, 수고하세요.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }else{
            let resultAlert = UIAlertController(title: "ERR😵R", message: "에러가 발생 되었습니다. \n고객센터에 문의 해 주세요.\n전화번호 : 02-111-2222", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
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
    
}

extension MJWithdrawalViewController:MJSelectOfUserInfoProtocol{
    func itemDownloaded(items: NSArray) { //NSArray 배열중에 가장큰 배열이다.
    }
}

