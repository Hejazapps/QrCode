//
//  SubscriptionVc.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 8/18/23.
//

import UIKit
import ProgressHUD
import StoreKit
import SwiftyStoreKit

class SubscriptionVc: UIViewController,UIScrollViewDelegate {
    var completeOnboarding : (() -> Void)?
    var presentMainTabOnAnyAction = false
    
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var heightConstrainOfWholeView: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mostPopularView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var weeklyView: UIView!
    
    @IBOutlet weak var offerLabel: UILabel!
    
    
  
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    var currentSelectedSub = 0
    
    let subColor =  UIColor(red: 33.0/255, green: 187.0/255, blue: 69.0/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.delegate = self
       
        
        self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.1)
        
       
        self.checkColorStatus()
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
        
        
        offerLabel.layer.cornerRadius =  offerLabel.frame.size.height / 2.0
        offerLabel.clipsToBounds = true
    }
    func checkColorStatus() {
        
        label1.backgroundColor = UIColor.clear
        label2.backgroundColor = UIColor.clear
        label3.backgroundColor = UIColor.clear
     
        
        label1.textColor = UIColor.black
        label2.textColor = UIColor.black
        label3.textColor = UIColor.black
        
        if currentSelectedSub == 1 {
            
            label1.backgroundColor = subColor
            label1.textColor = UIColor.white
        }
        
        if currentSelectedSub == 0 {
            
            label2.backgroundColor = subColor
            label2.textColor = UIColor.white
        }
        
        if currentSelectedSub == 2 {
            
            label3.backgroundColor = subColor
            label3.textColor = UIColor.white
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    @IBAction func gotoDismiss(_ sender: Any) {
        completeOnboarding?()
        
        if presentMainTabOnAnyAction {
            performSegue(withIdentifier: "onboardMainTabSegue", sender: nil)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let lastContentOffset = scrollView.contentOffset.y
        
        
        print(lastContentOffset)
    }
    
    
    @IBAction func weeklyView(_ sender: Any) {
        
        self.purchaseItemIndex(index: 1)
        
    }
    
    
    @IBAction func MostPopularview(_ sender: Any) {
        
        self.purchaseItemIndex(index: 0)
    }
    
    
    @IBAction func gotoMonthlyView(_ sender: Any) {
        self.purchaseItemIndex(index: 2)
    }
    
    
    func buyAproduct(value:String)
    {
        SwiftyStoreKit.purchaseProduct(value, quantity: 1, atomically: false) { result in
            switch result {
            case .success(let product):
                // fetch content from your server, then:
                if product.needsFinishTransaction {
                    Store.sharedInstance.setPurchaseActive(value: true)
                    Store.sharedInstance.verifyReciept()
                    ProgressHUD.dismiss()
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: ProgressHUD.dismiss()
                case .clientInvalid: ProgressHUD.dismiss()
                case .paymentCancelled:  ProgressHUD.dismiss()
                case .paymentInvalid: ProgressHUD.dismiss()
                case .paymentNotAllowed:  ProgressHUD.dismiss()
                case .storeProductNotAvailable:ProgressHUD.dismiss()
                case .cloudServicePermissionDenied: ProgressHUD.dismiss()
                case .cloudServiceNetworkConnectionFailed: ProgressHUD.dismiss()
                case .cloudServiceRevoked: ProgressHUD.dismiss()
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    
    
    private func purchaseItemIndex(index: Int) {
        
        currentSelectedSub = index;
        
        self.checkColorStatus()
       
        
    }
    func checkSub(index:Int) {
        DispatchQueue.main.async{
            
            ProgressHUD.animate("Purchasing...", interaction: false)
            
        }
        
        var productId =
            [PoohWisdomProducts.yearlySub, PoohWisdomProducts.weeklySub,PoohWisdomProducts.monthlySub]
        
        self.buyAproduct(value: productId[index])
        
        return
            
            Store.sharedInstance.setCurrentItem(value: productId[index])
        PoohWisdomProducts.store.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            guard success else {
                
                DispatchQueue.main.async {
                    
                    //ERProgressHud.sharedInstance.hide()
                    let alertController = UIAlertController(title: "Failed to load list of products",
                                                            message: "Check logs for details",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    
                }
                
                
                return
            }
            PoohWisdomProducts.store.buyProduct(products![0] as SKProduct) { [weak self] success, productId in
                guard let self = self else {
                    
                   // return
                    
                }
                guard success else {
                    
                    return
                }
                
            }
        }
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

