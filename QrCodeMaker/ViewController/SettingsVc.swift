//
//  SettingsVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit
import StoreKit

class SettingsVc: UIViewController {

    @IBOutlet weak var historySwitch: UISwitch!
    @IBOutlet weak var linkOpen: UISwitch!
    @IBOutlet weak var beepSwitch: UISwitch!
    @IBOutlet weak var vibrateWatch: UISwitch!
    @IBOutlet weak var soundWatch: UISwitch!
    @IBOutlet weak var HeightForTotal: NSLayoutConstraint!
    @IBOutlet weak var holderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(holderView.frame.origin.y)
        print(holderView.frame.size.height)
        
        HeightForTotal.constant = holderView.frame.origin.y + holderView.frame.size.height + 50
    }
    
    
    @IBAction func gotoSubscription(_ sender: Any) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionVc") as! SubscriptionVc
        initialViewController.modalPresentationStyle = .fullScreen
        self.present(initialViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if soundWatch.isOn {
            UserDefaults.standard.set(2, forKey: "sound")
        } else {
            UserDefaults.standard.set(1, forKey: "sound")
        }
        
        if historySwitch.isOn {
            UserDefaults.standard.set(2, forKey: "history")
        } else {
            UserDefaults.standard.set(1, forKey: "history")
        }
        
        if vibrateWatch.isOn {
            UserDefaults.standard.set(2, forKey: "vibrate")
        } else {
            UserDefaults.standard.set(1, forKey: "vibrate")
        }
        
        if beepSwitch.isOn {
            UserDefaults.standard.set(2, forKey: "Beep")
        } else {
            UserDefaults.standard.set(1, forKey: "Beep")
        }
        
        if linkOpen.isOn {
            UserDefaults.standard.set(2, forKey: "Link")
        } else {
            UserDefaults.standard.set(1, forKey: "Link")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let a = UserDefaults.standard.integer(forKey: "sound")
        let b = UserDefaults.standard.integer(forKey: "vibrate")
        let c = UserDefaults.standard.integer(forKey: "Beep")
        let d = UserDefaults.standard.integer(forKey: "Link")
        let e = UserDefaults.standard.integer(forKey: "history")
        
        if a == 2 {
            soundWatch.setOn(true, animated: true)
        }
        else {
            soundWatch.setOn(false, animated: true)
        }
        
        if b == 2 {
            vibrateWatch.setOn(true, animated: true)
        }
        else {
            vibrateWatch.setOn(false, animated: true)
        }
        
        if c == 2 {
            beepSwitch.setOn(true, animated: true)
        }
        else {
            beepSwitch.setOn(false, animated: true)
        }
        
        if d == 2 {
            linkOpen.setOn(true, animated: true)
        }
        else {
            linkOpen.setOn(false, animated: true)
        }
        
        if e == 2 {
            historySwitch.setOn(true, animated: true)
        }
        else {
            historySwitch.setOn(false, animated: true)
        }
       
        
        
    }
    
    
    @IBAction func gotoTermOfUse(_ sender: Any) {
        
        self.gotoWebView(name: "Terms of Use", url: termsOfUseValue)
        
    }
    
    
    @IBAction func gotoPrivacyPolicy(_ sender: Any) {
        
        self.gotoWebView(name: "Privacy Policy", url: privacyPolicyValue)
        
    }
    
    @IBAction func rateThisApp(_ sender: Any) {
        SKStoreReviewController.requestReview()
        
    }
    
    func gotoWebView(name:String,url:String)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommonViewController") as? CommonViewController
        vc?.titleForValue = name
        vc?.url = url
        let navController = UINavigationController(rootViewController: vc!) // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
}
