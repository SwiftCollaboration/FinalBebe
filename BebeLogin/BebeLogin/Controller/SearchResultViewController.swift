//
//  SearchResultViewController.swift
//  BabyProject
//
//  Created by 박재원 on 2021/08/02.
//

import UIKit

class SearchResultViewController: UITableViewController {

    /// Outlet
    @IBOutlet var searchResultTableView: UITableView!
    
    /// Search Keyword
    var searchWord:String = ""
    
    /// Array
    var feedItem: NSArray = NSArray()
   
    /// SearchBar
    let searchController = UISearchController(searchResultsController: nil)
    
    /// Prepare
    func searchWord(searchWith: String) {
        searchWord = searchWith
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ResultView :\(searchWord)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
      
        
        let searchModel = SearchModel()              // * * * * * * * * *
        searchModel.delegate = self                  // *   DB 불러오기   *
        searchModel.downloadItems(subUrl: searchWord)// * * * * * * * * *
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        navigationTitleSetting()                // NaviBar Setting
    
    } // viewDidLoad

    /// Navigation Setting
    func navigationTitleSetting(){
        self.title = self.searchWord                                    // Navi Title
        self.navigationController?.navigationBar.tintColor = .gray      // NaviBar 색상 바꾸기
        self.navigationController?.navigationBar.topItem?.title = ""    // Back Button title 없애기
        
    } // navigationTitleSetting
    
    // MARK: - Table view data source
    
    /// Cell 높이 지정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(150)
        return height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }

    /// Cell Data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableCell", for: indexPath) as! SearchResultTableCell

        // Configure the cell...
        let item: SearchDBModel = feedItem[indexPath.row] as! SearchDBModel
        
        // Cell Customizing
        cell.cornerRadius = 15
        cell.searchImageView.image = UIImage(named: "\(item.itemimage ?? "basicImage.png")")
        cell.lblSearchTitle.text = item.itemtitle                   // 제목 : itemtitle
        cell.lblSearchDate.text = item.uploaddate                   // 판매등록날짜 : uploaddate
        cell.btnSearchUseage.setTitle(item.useage, for: .normal)    // Button : useage
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
        
        // 클릭한 셀의 정보 가져오기
        // segue 이름이 "sgDetail"이면
        if segue.identifier == "sgResultToItemDetail"{
            let cell = sender as! UITableViewCell // sender를 이용해서 UITableViewCell과 연결
            let indexPath = self.searchResultTableView.indexPath(for: cell) // 클릭한 셀의 indexPath를 가져옴
            
            let detailView = segue.destination as! ItemDetailBuyerViewController // sender를 이용해서 ItemDetailBuyerViewController과 연결
            
            // 클릭한 셀의 내용을 DBModel로 변환
            let item: SearchDBModel = feedItem[indexPath!.row] as! SearchDBModel
            // 클릭한 셀의 indexPath의 Data를 가져옴
            detailView.receiveItems(item.itemcode!)
        }
        
        
    }
    

}

/// Protocol : DB * * * * * *
extension SearchResultViewController: SearchModelProtocol{
    func itemDownloaded(items: NSArray) {
        feedItem = items
        
        // * * * Data 받아온 시점 * * *
        self.searchResultTableView.reloadData()
    }
    
} // SearchViewController: KeywordModelProtocol
