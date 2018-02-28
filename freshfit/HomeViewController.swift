import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OutfitModelProtocol {
    
    
    var feedItems: NSArray = NSArray()
    var selectedOutfit : OutfitModel = OutfitModel()

    @IBOutlet weak var labelUserName: UILabel!
    
    @IBAction func buttonLogout(_ sender: UIButton) {
        
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(loginViewController, animated: false)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    

    @IBOutlet weak var listTableView: UITableView!
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: OutfitModel = feedItems[indexPath.row] as! OutfitModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.name
        
        return myCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        let outfitModel = OutfitModel()
        outfitModel.delegate = self
        outfitModel.downloadItems()
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        let userID = defaultValues.string(forKey: "userid")!
        if let name = defaultValues.string(forKey: "username"){
            //setting the name to label
            self.labelUserName.text = name + " ("+userID+")"
        }else{
            //send back to login view controller
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
