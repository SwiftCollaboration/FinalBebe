//
//  ChatListTableViewController.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import UIKit

class ChatListTableViewController: UITableViewController {

    @IBOutlet var tvChat: UITableView!
    
    var chatListItem: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let chatListSelectModel = ChatListSelectModel()
        chatListSelectModel.delegate = self
        chatListSelectModel.chatListSelectItems()
        
        tvChat.rowHeight = 120
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatListItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatListTableViewCell

        // Configure the cell...
        let item: ChatListDBModel = chatListItem[indexPath.row] as! ChatListDBModel
        
        // 아이템 이미지
        let url = URL(string: share.imgUrl("\(item.itemimage!)"))
        let data = try? Data(contentsOf: url!)
        cell.ivItem.image = UIImage(data: data!)
        
        // 날짜, 최근 메세지
        cell.lblDate?.text = "\(item.senddate!)"
        cell.lblMessage?.text = "\(item.message!)"
        
        // 채팅 상대 닉네임
        if item.sellerNickName == Share.userNickName {
            cell.lblNickname?.text = "\(item.buyerNickName!)"
        }else {
            cell.lblNickname?.text = "\(item.sellerNickName!)"
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sgRoomToChat" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvChat.indexPath(for: cell)
            
            let item: ChatListDBModel = chatListItem[indexPath!.row] as! ChatListDBModel
            
            let chatView = segue.destination as! ChatViewController
            
            var scoreType = ""
            
            if item.sellerNickName == Share.userNickName {
                scoreType = "buyerscore"
                chatView.receiveItems(item.roomcode!, item.itemcode!, item.itemtitle!, item.itemimage!, item.buyerNickName!, scoreType, item.sellerEmail!, item.buyerEmail!, item.buyerEmail!)
            }else {
                scoreType = "sellerscore"
                chatView.receiveItems(item.roomcode!, item.itemcode!, item.itemtitle!, item.itemimage!, item.sellerNickName!, scoreType, item.sellerEmail!, item.buyerEmail!, item.sellerEmail!)
            }
//            chatView.receiveItems(item.roomcode!, item.itemcode!, item.itemtitle!, item.itemimage!, nickName)
        }
    }
    

}

// NSArray: String Int를 선언 안하고도 같이 넣을 수 있는 array (가장 상위 버전의 Array)
extension ChatListTableViewController: ChatListSelectModelProtocol {
    func itemDeownloaded(items: NSArray) {
        chatListItem = items
        self.tvChat.reloadData()
    }
}
