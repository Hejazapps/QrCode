//
//  HeaderViewTableViewCell.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 7/7/23.
//

import UIKit

class HeaderViewTableViewCell: UITableViewCell {

    @IBOutlet weak var pro1: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
