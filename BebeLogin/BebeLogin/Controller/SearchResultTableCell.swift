//
//  SearchResultTableCell.swift
//  BebeLogin
//
//  Created by 박재원 on 2021/08/05.
//

import UIKit

class SearchResultTableCell: UITableViewCell {

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var lblSearchDate: UILabel!
    @IBOutlet weak var lblSearchTitle: UILabel!
    @IBOutlet weak var btnSearchUseage: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
