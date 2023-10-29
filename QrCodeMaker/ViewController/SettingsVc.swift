//
//  SettingsVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit

class SettingsVc: UIViewController {

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let a = UserDefaults.standard.integer(forKey: "sound")
        let b = UserDefaults.standard.integer(forKey: "vibrate")
        
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
        print(a)
        
        print("sound =  \(a)")
        
        
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
