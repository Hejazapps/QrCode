//
//  InputTextTableViewCell.swift
//  QrCode&BarCodeMizan
//
//  Created by Macbook pro 2020 M1 on 17/3/23.
//

import UIKit

class InputTextTableViewCell: UITableViewCell {
    @IBOutlet weak var textViewContainer: UIView!

    @IBOutlet weak var switchF: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var label: UILabel!
    
    var minHeight: CGFloat?
    @IBOutlet weak var networkName: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configCell(){
        self.textViewContainer.layer.shadowColor = UIColor.lightGray.cgColor
            //UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1).cgColor
        self.textViewContainer.layer.shadowOffset = .zero
        self.textViewContainer.layer.shadowColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1).cgColor
        self.textViewContainer.layer.shadowRadius = 2
        self.textViewContainer.layer.shadowOpacity = 1
        self.textViewContainer.layer.cornerRadius = 8
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
