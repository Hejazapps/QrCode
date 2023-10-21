//
//  SettingsVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit

class SettingsVc: UIViewController {

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // DBmanager.shared.initDB()
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
