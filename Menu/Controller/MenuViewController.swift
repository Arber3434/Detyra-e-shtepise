import UIKit
import WebKit
import NVActivityIndicatorView

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var webView: WKWebView!
    var isMenuOpen: Bool = false
    
    var progressView: UIProgressView!
    
   var menuItems = ["Home", "Rreth Nesh", "Trajnimet", "CacttuKids", "Projektet"]
    var menuUrls: [String] = ["https://cacttus.education", "https://cacttus.education/per-shkollen/", "https://cacttus.education/trajnimet-profesionale/", "https://cacttus.education/cacttukids/",
        "https://cacttus.education/usaid/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenu()
        setUpMenuTable()
        setupWebView()
        hideLoader()
            
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func showLoader(){
        loaderView.isHidden = false
        let loaderSize = CGSize(width: 20.0, height: 20.0)
        
        startAnimating(loaderSize, message: "Loading", type: .ballClipRotateMultiple, color: .purple, textColor: .white, fadeInAnimation: nil)
    }
    
    func hideLoader(){
        loaderView.isHidden = true
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    
    func setUpMenu(){
        menuView.frame = CGRect(x: self.mainView.frame.width*2, y: 0, width: self.mainView.frame.width/2, height: self.mainView.frame.height)
        self.mainView.addSubview(menuView)
    }
        
    @IBAction func menuPressed(_ sender: Any) {
        if(isMenuOpen == false){
            showMenu()
        }else{
            closeMenu()
        }
    }
    
    func showMenu(){
        UIView.animate(withDuration: 0.5) {
            self.menuView.frame = CGRect(x: 250, y: 0, width: self.mainView.frame.width,
        height: self.mainView.frame.height*2)
        }
        isMenuOpen = true
    }
    
    func closeMenu(){
        UIView.animate(withDuration: 0.5) {
            self.menuView.frame = CGRect(x: self.mainView.frame.width*2, y: 0, width: self.mainView.frame.width/2, height: self.mainView.frame.height)
        }
        isMenuOpen = false
    }
    
    //setUpTableView
    
    func setUpMenuTable(){
        menuTable.delegate = self
        menuTable.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell")!
        
        if let itemNameLabel = cell.viewWithTag(10) as? UILabel{
            itemNameLabel.text = menuItems[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadPage(urlString: menuUrls[indexPath.row])
        closeMenu()
    }

    //set up Web View
    func setupWebView(){
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    func loadPage(urlString: String){
        showLoader()
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish loading")
        hideLoader()
    }
}
