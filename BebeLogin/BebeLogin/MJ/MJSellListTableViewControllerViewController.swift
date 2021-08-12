//
//  MJSellListTableViewControllerViewController.swift
//  BabyProject
//
//  Created by 김민재 on 2021/08/02.
//

import UIKit

class MJSellListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var segmentedSellSelect: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var feedItem:NSArray = NSArray() //NSArray 은 배열중에 가장큰 배열이다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Cell의 크기를 정한다.
        tableView.rowHeight = 120
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //segmented
    @IBAction func segmentedSellSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            let MJDBItemlist = MJSelectOfSellItemListIsNull()
            MJDBItemlist.delegate = self
            MJDBItemlist.downloadItems()
        }else if sender.selectedSegmentIndex == 1{
            let MJDBItemlist = MJSelectOfSellItemListIsNotNull()
            MJDBItemlist.delegate = self
            MJDBItemlist.downloadItems()
        }
    }
    
    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        let MJDBItemlist = MJSelectOfSellItemListIsNull()
        MJDBItemlist.delegate = self
        MJDBItemlist.downloadItems()
    }
    
    
    
    @nonobjc func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }
    
    
    @objc(tableView:cellForRowAtIndexPath:) internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfSellList", for: indexPath) as! MJISellListTableViewCell
        // Configure the cell...
        let item: MJDBItemlist = feedItem[indexPath.row] as! MJDBItemlist
        let url = URL(string: "http://\(Share.ipaddress)/bebeProject/image/\(item.itemimage!)")
        let data = try? Data(contentsOf: url!)
        
        cell.imageVIewItemImage?.image = UIImage(data: data!)
        cell.labelItemTitle?.text = "\(item.itemtitle!)"
        cell.labelAddress?.text = "지역 : \(item.address!)"
        cell.labelUseAge?.text = "\(item.useage!) 개월"
        
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
        
        // 클릭한 셀의 정보 가져오기
        // segue 이름이 "sgDetail"이면
        if segue.identifier == "sgMypageGoToItemSellerView"{
            let cell = sender as! UITableViewCell // sender를 이용해서 UITableViewCell과 연결
            let indexPath = self.tableView.indexPath(for: cell) // 클릭한 셀의 indexPath를 가져옴
            
            let detailView = segue.destination as! ItemDetailSellerViewController // sender를 이용해서 ItemDetailSellerViewController과 연결
            
            // 클릭한 셀의 내용을 DBModel로 변환
            let item: MJDBItemlist = feedItem[indexPath!.row] as! MJDBItemlist
            // 클릭한 셀의 indexPath의 Data를 가져옴
            detailView.receiveItems(item.itemcode!)
        }
        
     }
     
     
    
}

extension MJSellListTableViewController:MJSelectOfItemListProtocol{
    func itemDownloaded(items: NSArray) { //NSArray 은 배열중에 가장큰 배열이다.
        feedItem = items
        self.tableView.reloadData()
    }
}
