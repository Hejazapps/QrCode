//
//  FirstLandingViewController.swift
//  QrCodeMaker
//
//  Created by Md. Ikramul Murad on 18/2/24.
//

import UIKit

class FirstLandingViewController: UIViewController {
    @IBOutlet weak var linkTextView: LinkTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSub()
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
