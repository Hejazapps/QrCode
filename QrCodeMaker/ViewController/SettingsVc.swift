//
//  SettingsVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit
import StoreKit
import MessageUI

class SettingsVc: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var heightforsetting: NSLayoutConstraint!
    @IBOutlet weak var historySwitch: UISwitch!
    @IBOutlet weak var linkOpen: UISwitch!
    @IBOutlet weak var beepSwitch: UISwitch!
    @IBOutlet weak var vibrateWatch: UISwitch!
    @IBOutlet weak var soundWatch: UISwitch!
    @IBOutlet weak var HeightForTotal: NSLayoutConstraint!
    @IBOutlet weak var holderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        soundWatch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        vibrateWatch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
       // beepSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        historySwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        linkOpen.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("purchaseNoti"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        heightforsetting.constant = 0
        
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(holderView.frame.origin.y)
        print(holderView.frame.size.height)
        
        HeightForTotal.constant = holderView.frame.origin.y + holderView.frame.size.height + 50
    }
    
    
    
    
    @IBAction func gotoSubscription(_ sender: Any) {
        
        
        if currentReachabilityStatus == .notReachable {
            self.showAlert()
            return
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionVc") as! SubscriptionVc
        initialViewController.modalPresentationStyle = .fullScreen
        initialViewController.isfromPro =  false
        self.present(initialViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        let a = UserDefaults.standard.integer(forKey: "sound")
        let b = UserDefaults.standard.integer(forKey: "vibrate")
        let c = UserDefaults.standard.integer(forKey: "Beep")
        let d = UserDefaults.standard.integer(forKey: "Link")
        let e = UserDefaults.standard.integer(forKey: "history")
        
        
        if(Store.sharedInstance.isActiveSubscription()) {
            
            heightforsetting.constant = 0
        }
        
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
        
        
        if currentReachabilityStatus == .notReachable {
            self.showAlert()
            
        } else {
            self.gotoWebView(name: "Terms of Use", url: termsOfUseValue)
        }
        
        
        
        
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "", message: "Check Your Internet!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    func sendEmail(subject:String?,mailAddress:String?,cc:String?,meessage:String?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.modalPresentationStyle = .fullScreen
            if let mailAddressV = mailAddress
            {
                mail.setToRecipients([mailAddressV])
            }
            if let meessageV = meessage
            {
                mail.setMessageBody(meessageV, isHTML: false)
            }
            
            if let subjectV = subject
            {
                mail.setSubject(subjectV)
            }
            if let cctV = cc
            {
                mail.setCcRecipients([cctV])
            }
            
            present(mail, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Note", message: "Email is not configured!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func gotoPrivacyPolicy(_ sender: Any) {
        
        
        if currentReachabilityStatus == .notReachable {
            self.showAlert()
            
        } else {
            self.gotoWebView(name: "Privacy Policy", url: privacyPolicyValue)
        }
        
    }
    
    @IBAction func rateThisApp(_ sender: Any) {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
        
    }
    
    
    @IBAction func sendFeedBack(_ sender: Any) {
        
        
        self.sendEmail(subject: "Send Us FeedBack", mailAddress: "assistance.scannr@gmail.com", cc: "", meessage: "")
        
    }
    
    @IBAction func shareTheApp(_ sender: Any) {
        
        if let link = NSURL(string: "https://apps.apple.com/in/app/qr-code-barcode-scanner-pro/id1511139064") {
            let objectsToShare = ["Hi, download this cool app now!",link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    func gotoWebView(name:String,url:String)
    
    {
        
        
        if currentReachabilityStatus == .notReachable {
            self.showAlert()
            return
            
        }
        
        
        guard let url = URL(string:  url) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
        
        
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
