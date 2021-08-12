//
//  UserSearchCell.swift
//  BebeLogin
//
//  Created by 박재원 on 2021/08/05.
//

import UIKit

class UserSearchCell: UITableViewCell {

    
    @IBOutlet weak var lblSearchContent: UILabel!
    
    @IBOutlet weak var lblSearchDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
