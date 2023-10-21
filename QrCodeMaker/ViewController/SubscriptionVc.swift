//
//  SubscriptionVc.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 8/18/23.
//

import UIKit

class SubscriptionVc: UIViewController,UIScrollViewDelegate {
    
    
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var heightConstrainOfWholeView: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mostPopularView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var weeklyView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.delegate = self
       
        
        self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.1)

        self.setRoundedView(view: weeklyView, radius: 9)
        self.setRoundedView(view: monthlyView, radius: 9)
        self.setRoundedView(view: mostPopularView, radius: 15)
        // Do any additional setup after loading the view.
    }
    
    func setRoundedView(view:UIView,radius:Int){
        view.layer.cornerRadius =  CGFloat(radius)
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor(red: 33.0/255, green: 187.0/255, blue: 69.0/255, alpha: 1.0).cgColor
        view.clipsToBounds = true
    }


    @IBAction func gotoDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let lastContentOffset = scrollView.contentOffset.y
        
        
        print(lastContentOffset)
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            mainScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
        }
    }
    
    @objc fileprivate func targetMethod(){
        mainScrollView.contentOffset.y = 0
        heightConstrainOfWholeView.constant = holderView.frame.origin.y + middleView.frame.origin.y  + 70
         
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

