//
//  ThirdLandingViewController.swift
//  QrCodeMaker
//
//  Created by Md. Ikramul Murad on 17/2/24.
//

import UIKit

class ThirdLandingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func swiped(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.navigationController?.popViewController(animated: true)
        } else {
            print("swipe direction: \(sender.direction)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "onboardPurchaseSegue" else { return }
        
        let destination = segue.destination as! SubscriptionVc // change that to the real class
        destination.completeOnboarding = {
            UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        }
        destination.presentMainTabOnAnyAction = true
    }
}
