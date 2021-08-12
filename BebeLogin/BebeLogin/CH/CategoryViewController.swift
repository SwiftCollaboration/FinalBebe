//
//  CategoryViewController.swift
//  BabyProject
//
//  Created by 이찬호 on 2021/07/30.
//

import UIKit

var CategoryList = ["","의류","침구","이유식","목욕용품","위생용품","스킨케어","외출용품","완구"]
var CategoryImage: [UIImage] = [UIImage(named: "All.png")!,UIImage(named: "cloth.png")!,UIImage(named: "bed.png")!,UIImage(named: "food.png")!,UIImage(named: "bath.png")!,UIImage(named: "item.png")!,UIImage(named: "skincare.png")!,UIImage(named: "outside.png")!,UIImage(named: "toy.png")!]
var CategoryImage2: [UIImage] = [UIImage(named: "All_2.png")!,UIImage(named: "cloth_2.png")!,UIImage(named: "bed_2.png")!,UIImage(named: "food_2.png")!,UIImage(named: "bath_2.png")!,UIImage(named: "item_2.png")!,UIImage(named: "skincare_2.png")!,UIImage(named: "outside_2.png")!,UIImage(named: "toy_2.png")!]




class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgSendCategory"{
            let cell = sender as! CategoryCollectionViewCell
            let indexPath = self.categoryCollectionView.indexPath(for: cell)
            let mainView = segue.destination as! MainHomeTableViewController
            mainView.recieveItem = String(CategoryList[(indexPath?.row)!])
            print("클릭 확인 : \(String(CategoryList[indexPath!.row]))")
            print("리시브아이템도 : \(mainView.recieveItem)")
            
        }
    }
    

}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryList.count
    }
    
    //return형식이 UICollectionViewCell 타입이다
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.lblCategory.text = CategoryList[indexPath.row]
        //cell.imgViewCategory.image = CategoryImage[indexPath.row]
        cell.imgViewCategory.image = CategoryImage2[indexPath.row]

        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sgSendCategory"{
//            let cell = sender as! CategoryCollectionViewCell
//            let indexPath = self.categoryCollectionView.indexPath(for: cell)
//            let mainView = segue.destination as! MainHomeTableViewController
//            mainView.recieveItem = String(CategoryList[(indexPath?.row)!])
//            print("클릭 확인 : \(String(CategoryList[indexPath!.row]))")
//            print("리시브아이템도 : \(mainView.recieveItem)")
//
//        }
//   }
    
} //CategoryViewController


//Cell Layout 정의
extension CategoryViewController: UICollectionViewDelegateFlowLayout{
    
    // 위 아래 간격 주기(minimumLineSpacing)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 옆 간격 (minimumitemSpacing)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //cell 사이즈 (옆 라인을 고려하여 설정 sizeforIte)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 3등분하영 배치, 옆 간격이 1이므로 1을 빼줌
        let width = collectionView.frame.width / 3 - 1
        let size = CGSize(width: width, height: width)
        return size
    }
}







