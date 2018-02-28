//
//  ViewController.swift
//  freshfit
//
//  Created by Steve Weldon on 2/22/18.
//  Copyright © 2018 FreshFit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Flask register
    let defaultValues = UserDefaults.standard
    
    // View variables
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        
        if(usernameField.text! != ""){
            
            let url = URL(string: "http://localhost/freshfit/login.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "username=\(usernameField.text!)&password=\(passwordField.text!)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                
                
                DispatchQueue.main.async{
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        
                        let jsonData = json as NSDictionary
                        
                        //if there is no error
                        if(!(jsonData.value(forKey: "error") as! Bool)){
                            
                            //getting the user from response
                            let user = jsonData.value(forKey: "user") as! NSDictionary
                            
                            //getting user values
                            let userName = user.value(forKey: "username") as! String
                            let userIdInt = user.value(forKey: "id") as! Int
                            var userID = String(userIdInt)
                            //saving user values to defaults
                            self.defaultValues.set(userName, forKey: "username")
                            self.defaultValues.set(userID, forKey: "userid")
                            
                            //switching the screen
                            

                            
                            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewcontroller") as! HomeViewController
                    
                            let transition:CATransition = CATransition()
                            transition.duration = 0.3
                            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                            transition.type = kCATransitionPush
                            transition.subtype = kCATransitionFromRight
                            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
                            self.navigationController?.pushViewController(homeViewController, animated: false)
                            self.dismiss(animated: false, completion: nil)
                        }else{
                            //error message in case of invalid credential
                            print("Invalid username or password")
                        }
                        
                        
                    } catch let error as NSError {
                        print(error)
                    }
                    
                }
                
            }
            task.resume()
            
        }else{
            print("No username provided for login")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hiding the navigation button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in switching to profile screen
        if defaultValues.string(forKey: "username") != nil{
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewcontroller") as! HomeViewController
            let transition: CATransition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController!.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(homeViewController, animated: false)
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

