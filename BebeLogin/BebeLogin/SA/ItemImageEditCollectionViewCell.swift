//
//  ItemImageEditCollectionViewCell.swift
//  BebeLogin
//
//  Created by Seong A Oh on 2021/08/03.
//

import UIKit

class ItemImageEditCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemEditImageView: UIImageView!
    @IBOutlet weak var btnItemImageRemove: UIButton!
    
    @IBAction func btnItemImageRemoveAction(_ sender: UIButton) {
        // 컬랙션뷰의 데이터를 먼저 삭제 해주고, 데이터 배열의 값을 삭제해줍니다!! , '반대로할시에 데이터가 꼬이는 현상이 발생합니다.'

//        itemAddCollectionView.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        itemImageArray.remove(at: sender.tag)

        print("이미지 갯수는 \(itemImageArray.count)")
                                          
    
    }
    
    
    
}
