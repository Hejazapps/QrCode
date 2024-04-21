//
//  FirstLandingViewController.swift
//  QrCodeMaker
//
//  Created by Md. Ikramul Murad on 18/2/24.
//

import UIKit
import SwiftyStoreKit

class FirstLandingViewController: UIViewController {
    @IBOutlet weak var linkTextView: LinkTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        Store.sharedInstance.verifyReciept()
        retriveProduct()
        
        let pp = "Privacy Policy"
        let ua = "User Agreements"
        
        linkTextView.addLinks([
            pp: "https://sites.google.com/view/scannr-privacy",
            ua: "https://sites.google.com/view/scannr-terms"
        ])
        linkTextView.onLinkTap = { url in
            print("url: \(url)")
            return true
        }
    }
}
