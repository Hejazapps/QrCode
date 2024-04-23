//
//  IconViewColl.swift
//  QrCode&BarCodeMizan
//
//  Created by Macbook pro 2020 M1 on 13/3/23.
//

import UIKit

protocol sendIndex {
    func btnTag(index: Int)
}


class IconViewColl: UICollectionViewCell {
    
    public var delegateForbtnTag: sendIndex?

    @IBOutlet weak var imv1: UIImageView!
    @IBOutlet weak var imv2: UIImageView!
    @IBOutlet weak var imv3: UIImageView!
    @IBOutlet weak var imv4: UIImageView!
    @IBOutlet weak var imv5: UIImageView!
    @IBOutlet weak var imv6: UIImageView!
    
    
    @IBOutlet weak var pro1: UIImageView!
    @IBOutlet weak var pro2: UIImageView!
    @IBOutlet weak var pro3: UIImageView!
    @IBOutlet weak var pro4: UIImageView!
    @IBOutlet weak var pro5: UIImageView!
    @IBOutlet weak var pro6: UIImageView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var heightForImv: NSLayoutConstraint!
    @IBOutlet weak var widthForBtn: NSLayoutConstraint!
    @IBOutlet weak var widthForLbl1: NSLayoutConstraint!
    @IBOutlet weak var widthForLbl2: NSLayoutConstraint!
    @IBOutlet weak var widthForlbl3: NSLayoutConstraint!
    @IBOutlet weak var widthForlbl4: NSLayoutConstraint!
    @IBOutlet weak var widthForLbl6: NSLayoutConstraint!
    @IBOutlet weak var widthForLbl5: NSLayoutConstraint!
    @IBOutlet weak var heightForBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func showBtnTag(_ sender: UIButton) {
        
        delegateForbtnTag?.btnTag(index: sender.tag - 700)
     
    }
    
    
    public static var reusableID: String {
        return String(describing: IconViewColl.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: reusableID, bundle: nil)
    }

}
