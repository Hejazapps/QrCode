//
//  ExpandableCellTableViewCell.swift
//  ExpandableTableView
//
//  Created by MacBook Pro Retina on 8/11/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit

class ExpandableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var leadingSpaceConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var sideImv: UIImageView!
    @IBOutlet var leadingSpace: NSLayoutConstraint!
    @IBOutlet weak var topSpaceLabel1: NSLayoutConstraint!
    @IBOutlet var widthForImv: NSLayoutConstraint!
    @IBOutlet var trailingSpace: NSLayoutConstraint!

    @IBOutlet var containerview: UIView!
    @IBOutlet var headerView1: UIView!
    @IBOutlet var newView: UIView!
    @IBOutlet var expandableView: UIView!

    @IBOutlet var lbl: UILabel!
    @IBOutlet var lbl1: UILabel!

    @IBOutlet var imv: UIImageView!

    @IBOutlet weak var roundedImv: UIImageView!
    @IBOutlet var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
