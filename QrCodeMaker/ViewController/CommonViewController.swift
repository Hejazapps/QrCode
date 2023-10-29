
import UIKit
import WebKit
import IHProgressHUD

class CommonViewController: UIViewController,WKNavigationDelegate {
    var url:String!
    
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var webView: WKWebView!
    var titleForValue:String!
    override func viewDidLoad() {
        
        webView = WKWebView(frame:
            CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height))

        DispatchQueue.main.async{
             IHProgressHUD.show()
        }
        super.viewDidLoad()
        let  urlf = URL(string: url)
        let urlRequest = URLRequest(url: urlf!)
        webView.navigationDelegate =  self
        webView.load(urlRequest)
        self.title = titleForValue
        self.view.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!)
    {
        
        DispatchQueue.main.async{
             IHProgressHUD.dismiss()
        }
        
        
    }
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error)
    { DispatchQueue.main.async{
         IHProgressHUD.dismiss()
        }
        
        
    }
    
}
