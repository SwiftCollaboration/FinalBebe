//
//  MainHomeTableViewController.swift
//  BabyProject
//
//  Created by 이찬호 on 2021/07/30.
//

import UIKit

class MainHomeTableViewController: UITableViewController {
    
    @IBOutlet var listTableView: UITableView!
    @IBOutlet weak var sgBabyAgeView: UISegmentedControl!
    
    var feedItem: NSArray = NSArray()
    
    var useAge: String = "전체선택"  // 개월수 선택(세그먼트 컨트롤)
    
    var recieveItem: String = "" // 카테고리에서 카테고리 명 받아오는 값
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // 탭바 숨길때는 true , 탭바 보일때는 false
        self.tabBarController?.tabBar.isHidden = false
        
        listTableView.rowHeight = 125
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {

        // navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
            resultCategory()
            
    }
    
    
    //------------------------------세그먼트컨트롤 추가------------------------------------
    
  
    
    
    @IBAction func scBabyAgeSelect(_ sender: UISegmentedControl) {
        switch sgBabyAgeView.selectedSegmentIndex {
        case 0:
            useAge = "전체선택"
            print(useAge)
            print(recieveItem)
            resultCategory()
        case 1:
            useAge = "12개월"
            print(useAge)
            print(recieveItem)
            resultOp()
        case 2:
            useAge = "24개월"
            print(useAge)
            print(recieveItem)
            resultOp()
        case 3:
            useAge = "36개월"
            print(useAge)
            print(recieveItem)
            resultOp()
        default:
            useAge = "없음"
            print(useAge)
            print(recieveItem)
            resultOp()
        }
        
       // print("useAge 출력 확인 : \(useAge)")
    }
    
    //-------------------전체, 카테고리 조건출력계산 함수--------------------------------
    
    func resultCategory(){
        if recieveItem == ""{
            // 최초 리스트 불러오기
            let homeSelectModel = HomeSelectModel()
            homeSelectModel.delegate = self
            homeSelectModel.downloadItems()
            print("recieveItem 상태 표시 : \(recieveItem)")
            print(useAge)
        }else{
            //카테고리 선택 받아와서 불러오기
            let categorySelectModel = CategorySelectModel()
            categorySelectModel.delegate = self
            categorySelectModel.downloadItems(category: recieveItem)
            print("카테고리 필터 실행")
            print(useAge)
        }
    }
    
    //-------------------useage조건 출력 함수------------------------------------
    
    func resultOp(){
        let homeOpSelectModel = HomeOpSelectModel()
        homeOpSelectModel.delegate = self
        homeOpSelectModel.downloadItems(useage: useAge, category: recieveItem)
    }

    //---------------------------------------------------------------------
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! MainHomeTableViewCell


        // Configure the cell...
        let item: HomeDBModel = feedItem[indexPath.row] as! HomeDBModel
        let url = URL(string: Share().imgUrl(item.itemimage!))
        let data = try? Data(contentsOf: url!)
        
        cell.lblTitle.text = item.itemtitle
        cell.lblAddress.text = item.address
        cell.imgView.image = UIImage(data: data!)
        // 버튼모양으로 추가하기ÒLLL
        cell.btnBabyAge.setTitle(item.useage, for: .normal)
    

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
        
        // 클릭시 상세화면으로 넘어갈경우 세그명 설정하시고 아이템 코드값 가져가시면됩니다.
        
        if segue.identifier == "sgHomeToItemDetail"{
            //셀정보 가져오는부분
            let cell = sender as! UITableViewCell
            let indexPath = self.listTableView.indexPath(for: cell)
            let item: HomeDBModel = feedItem[indexPath!.row] as! HomeDBModel

            let detailView = segue.destination as! ItemDetailBuyerViewController
            detailView.receiveItems(item.itemcode!)

            //아이템 코드값 확인 해보시고 지워주세요!
            print("아이템 코드값 : \(item.itemcode!)")
                
            }
                
        }
            

    } //MainHomeTableViewController

extension MainHomeTableViewController: HomeSelectModelProtocol{
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }

}
extension MainHomeTableViewController: CategorySelectModelProtocol{
    func itemDownloaded2(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }

}

extension MainHomeTableViewController: HomeOpSelectModelProtocol{
    func itemDownloaded3(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }

}

//extension MainHomeTableViewController: CategoryDelegate{
//    func categoryReceive(_ controller: LampViewController, category: String){
//        recieveItem = category
//    }
//}

