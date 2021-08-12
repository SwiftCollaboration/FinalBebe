//
//  SearchViewController.swift
//  BabyProject
//
//  Created by 박재원 on 2021/07/30.
//

import UIKit
import SnapKit
import SQLite3

/// CollectionView temp Data
private let bottomItems:[String] = [
    "모빌",
    "유아용 텀블러",
    "아기욕조",
    "카시트"]

class SearchViewController: UIViewController {

    /// Outlet
    // CollectionView
    @IBOutlet weak var collectionTopView: UICollectionView!
    @IBOutlet weak var collectionBottomView: UICollectionView!
    @IBOutlet weak var userSearchTableView: UITableView!
    @IBOutlet weak var backButtonItem: UIBarButtonItem!

    /// Array
    var feedItem: NSArray = NSArray()
    var tagArray:[(Int,String)] = []
    
    /// SQLite
    var db: OpaquePointer?
    var userSearchList:[UserSearches] = []
    
    /// SearchBar
    let searchController = UISearchController(searchResultsController: nil)
    var searchWord:String = ""
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250, height: 0))
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createSQLite()                         // SQLite table init
        setupNavigationbarView()               // Navigationbar Setting
        setupCollectionTopView()               // CollectionView (Top)
        setupCollectionBottomView()            // CollectionView (Bottom)
        collectionTopView.dataSource = self    // CollectionView : Extension
        userSearchTableView.dataSource = self  // TableView : Extension
        userSearchTableView.delegate = self    // TableView : Extension
        
    } // viewDidLoad
    

    /// viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        // navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Get Items from DB
        let keywordModel = KeywordModel()
        keywordModel.delegate = self
        keywordModel.downloadItems()
        selectValues()
        self.collectionTopView.reloadData()
        self.collectionBottomView.reloadData()
        self.userSearchTableView.reloadData()
        
    } // viewWillAppear
    
    func toSearchResult(searchWith: String) {
        searchWord = searchWith
        
        self.performSegue(withIdentifier: "sgSearchResult", sender: self)
    }
    
    /// 화면구성 * * * * * * * * * * * * * * * * * * * * *
    
    /// Navigationbar Setting
    func setupNavigationbarView(){
        searchBar.placeholder = "검색어를 입력해주세요"
        self.navigationItem.titleView = searchBar
        
    } // setupNavigationbarView
    
    /// NavigationBar SearchBar Button Action
    @IBAction func btnSearchBar(_ sender: UIBarButtonItem) {
        let search = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            print("search : \(search)")
        
        switch search {
        case "":
            self.toSearchResult(searchWith: search)
            searchBar.text?.removeAll()
        default:
            self.insertSearchValues(search)
            self.toSearchResult(searchWith: search)
            searchBar.text?.removeAll()
            print("Button")
        } // switch
            
        
    }
    
    /// TopCollectionView ( 상단 Collection View )
    // CollectionView 모양 구성 : flowLayout
    func setupCollectionTopView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 5, left: 16, bottom: 5, right: 16)
        
        collectionTopView.setCollectionViewLayout(flowLayout, animated: true)
        collectionTopView.delegate = self
        collectionTopView.dataSource = self
        collectionTopView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionBottomView.decelerationRate = .normal
        collectionTopView.register(CollectionTopViewCell.self, forCellWithReuseIdentifier: "topItemCell")
        
    } // setupCollectionTopView
    
    /// BottomCollectionView ( 하단 Collection View )
    // CollectionView 모양 구성 : flowLayout
    func setupCollectionBottomView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 17
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 5, left: 16, bottom: 5, right: 16)
        
        collectionBottomView.setCollectionViewLayout(flowLayout, animated: true)
        collectionBottomView.delegate = self
        collectionBottomView.dataSource = self
        collectionBottomView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionBottomView.decelerationRate = .normal
        collectionBottomView.register(CollectionBottomViewCell.self, forCellWithReuseIdentifier: "bottomItemCell")
    
    } // setupCollectionTopView
    /// * * * * * * * * * * * * * * * * * * *
    
    /// SQlite : Delete Func
    @IBAction func btnUserSearchDelete(_ sender: UIButton) {
        deleteSearchValues()
        self.userSearchTableView.reloadData()
        viewWillAppear(true)
    } // btnUserSearchDelete
    
    // MARK: - Navigation

    /// Prepare * * * * * *
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        // SearchBar
        if segue.identifier == "sgSearchResult" {
            let searchResultView2 = segue.destination as! SearchResultViewController
            searchResultView2.searchWord(searchWith: searchWord)
        }
        
        
        // CollectionView (Top) 통해서 Prepare
        if segue.identifier == "sgCollectionToResult" {

            let searchResultView = segue.destination as! SearchResultViewController
            searchResultView.searchWord(searchWith: searchWord)
            print("Collection Bottom Cell")
        }

 
        // TableView 통해서 넘어가는 Prepare
        if segue.identifier == "sgSearchResultFromTableCell" {
            let cell = sender as! UITableViewCell
            let indexPath = self.userSearchTableView.indexPath(for: cell)
            
            let searchResultView = segue.destination as! SearchResultViewController
            
            searchResultView.searchWord(searchWith: userSearchList[indexPath!.row].content)
            
            print("Table Cell")
        }
 
        
    } // prepare

    
    /// TableView Setting
    
    /// Tag Count
    func readtags() -> Array<(Int,String)> {
        print("Start func : readtags")
            var arr:[(Int,String)] = []
            var arraySorted:[(Int,String)] = []
            
            for i in 0..<feedItem.count{
                let item: KeywordDBModel = feedItem[i] as! KeywordDBModel
                let getSplits = item.tag?.split(separator: ",")
                
                for i in 0..<getSplits!.count{
                    let value = getSplits![i]
                    var count = 0
                    
                    for i in 0..<arr.count{
                        if value == arr[i].1{
                            count += 1
                            arr[i].0 += 1
                        }
                    }
                    switch count {
                    case 0:
                        arr.append((1,String(value)))
                    default:
                        break
                    }
                }
                arraySorted = arr.sorted(by: {$0.0 > $1.0})
                print(arraySorted)
            }
            return arraySorted
        } // readtags
    
    /// Searchbar
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// SQLite : CREATE TABLE * * * * * *
    func createSQLite(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserSearchData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            // SQLite가 열리지 않으면?
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS search(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, date TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errmsg)")
        }
        // CURRENT_TIMESTAMP
        selectValues()
    }

    /// SQLite : SELECT * * * * * *
    func selectValues() {
        // Init Array
        userSearchList.removeAll()
        
        // Query
        let queryString = "SELECT * FROM search"
        
        // Statement
        var stmt: OpaquePointer?
        
        //
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errmsg)")
            return
        }
        
        // 한줄씩 가져오기
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // Int 값 불러오기
            let id = sqlite3_column_int(stmt, 0)
            let content = String(cString: sqlite3_column_text(stmt, 1))
            let date = String(cString: sqlite3_column_text(stmt, 2))
            
            // Data 잘 들어갔나 확인
            print(id, content, date)
            
            // describing:
            userSearchList.append(UserSearches(id: Int(id), content: String(content), date: String(date)))
            
        }
        // 값이 들어왔으면 재구성
        self.userSearchTableView.reloadData()
    }
    
    /// SQLite : INSERT * * * * * *
    func insertSearchValues(_ search: String){
        var stmt: OpaquePointer?
        // 한글 깨짐 방지 (-1 는 2byte의 범위를 잡아주는 것이다)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

        let content = search
        print("content : \(content)")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        let currentDate = formatter.string(from: Date())
        let date = currentDate

        let queryString = "INSERT INTO search(content, date) VALUES (?,?)"

        // != SQLITE_OK 가 아니면 {  } 실행
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            return    // return 할께 없는게 이게 있으면? 그냥 함수를 빠져나가는 것이다!
        }

        // 1번째 VALUES(?) 처리
        if sqlite3_bind_text(stmt, 1, content, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding content : \(errmsg)")
            return
        }
        // 2번째 VALUES(?) 처리
        if sqlite3_bind_text(stmt, 2, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding date : \(errmsg)")
            return
        }
        // 실행시키기
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting search : \(errmsg)")
            return
        }

    }

    /// SQLite : DELETE * * * * * *
    func deleteSearchValues(){
        var stmt: OpaquePointer?
        // 한글 깨짐 방지 (-1 는 2byte의 범위를 잡아주는 것이다)
        _ = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "DELETE FROM search"
        
        // != SQLITE_OK 가 아니면 {  } 실행
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete : \(errmsg)")
            return    // return 할께 없는게 이게 있으면? 그냥 함수를 빠져나가는 것이다!
        }
        
        // 실행시키기
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting search : \(errmsg)")
            return
        }
        
        print("Search info delete successfully")
        
    } // deleteSearchValues
   
    
} // SearchViewController * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


/// Extension : UICollection  * * * * * * * * * * * *

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case self.collectionTopView:
            self.searchWord = tagArray[indexPath.row].1
            self.insertSearchValues(tagArray[indexPath.row].1)
            self.performSegue(withIdentifier: "sgCollectionToResult", sender: self)
           
        default:
            print("")
        
        }
        print("Collection Bottom Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spaceInterItem = CGFloat(15)
        
        return spaceInterItem
    }
    
    /// Cell 출력 갯수  * * * * * *
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionTopView:
            return readtags().count
        default:
            return bottomItems.count
            // 상단 Cell
        }
    } // collectionView

    
    
    /// Cell 내용 붙이기  * * * * * *
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.collectionTopView:
            // 상단 Cell
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "topItemCell", for: indexPath) as! CollectionTopViewCell
            
            topCell.configure(name: self.tagArray[indexPath.row].1)
            return topCell
        default:
            // 하단 Cell
            let BottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomItemCell", for: indexPath) as! CollectionBottomViewCell
            BottomCell.configure(name: bottomItems[indexPath.row])
            return BottomCell
        } // switch
     
    } // collectionView
    
    /// Cell Size * * * * * *
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        
        case self.collectionTopView:
            // 상단 Cell
            return CollectionTopViewCell.fittingSize(availableHeight: 45, name: self.tagArray[indexPath.item].1)
        default:
            // 하단 Cell
            return CollectionBottomViewCell.fittingSize(availableHeight: 45, name: bottomItems[indexPath.item])
        }
    } // collectionView
    
    
} // SearchViewController


///  상단 Cell 구성  * * * * * * * * * * * *
///   - cell identifire : topItemCell
final class CollectionTopViewCell: UICollectionViewCell {
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = CollectionTopViewCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.3888371885, green: 0.63126719, blue: 0.8909832835, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
} //  CollectionTopViewCell


///  하단 Cell 구성 * * * * * * * * * * * *
///   - cell identifire : bottomItemCell
final class CollectionBottomViewCell: UICollectionViewCell {
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = CollectionBottomViewCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
} // CollectionBottomViewCell


/// TableView Setting * * * * * *
extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    
    /// Table 출력 수
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    /// Table 최대 출력 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSearchList.count
    }
    
    /// Table Data 연결
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Custom Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell", for: indexPath) as! UserSearchCell
    
        // Data
        let item = userSearchList[indexPath.row]
        
        // Cell 에 Data 연결
        cell.lblSearchContent.text = item.content
        cell.lblSearchDate.text = item.date

        return cell
    }
    
    /// SQLite : DELETE - WHERE
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var stmt: OpaquePointer?
            // 한글 깨짐 방지 (-1 는 2byte의 범위를 잡아주는 것이다)
            _ = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

            let content = userSearchList[indexPath.row].content
            let queryString = "DELETE FROM search WHERE content = '\(content)'"
            print(queryString)
            
            // != SQLITE_OK 가 아니면 {  } 실행
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing delete : \(errmsg)")
                return    // return 할께 없는게 이게 있으면? 그냥 함수를 빠져나가는 것이다!
            }

            // 실행시키기
            if sqlite3_step(stmt) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure deleting search : \(errmsg)")
                return
            }
            
            // 오류가 있으면 return 으로 함수 밖으로 나가게 되기때문에 여기까지 오지 못한다.
            // 이게 print 되면 이상이 없다는 의미!
            print("Search info delete successfully")
            self.userSearchList.remove(at: indexPath.row)
            self.userSearchTableView.deleteRows(at: [indexPath], with: .fade)
        }
    } // SQLite : DELETE - WHERE
    
    
    
} // SearchViewController

/// Protocol : DB * * * * * *
extension SearchViewController: KeywordModelProtocol{
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.tagArray = readtags()
        print("Extension : feedItem : \(feedItem)")
        
        // * * * Data 받아온 시점 * * *
        self.userSearchTableView.reloadData()
        self.collectionTopView.reloadData()
    }
    
} // SearchViewController: KeywordModelProtocol
