//
//  OutfitModel.swift
//  freshfit
//
//  Created by Steve Weldon on 2/28/18.
//  Copyright © 2018 FreshFit. All rights reserved.
//

import Foundation

protocol OutfitModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class OutfitModel: NSObject, URLSessionDataDelegate{
    
    // Properties
    var id: Int?
    var user: String?
    var type: String?
    var last_worn: Date?
    var name: String?
    
    
    weak var delegate: OutfitModelProtocol!
    var data = Data()
    let urlPath: String = "http://localhost/freshfit/outfit_service.php"
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type: application/json")
        request.httpMethod = "POST"
        let postString = "userid=5"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }

            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data)
            }

        }

        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
   
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        let responseString = String(data: data, encoding: .utf8)
        
        var jsonElement = NSDictionary()
        let outfits = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            
            let outfit = OutfitModel()
            print(jsonElement["last_worn"]!)
            let id = jsonElement["id"]! as? Int
            let userid = jsonElement["user"]! as? String
            let type = jsonElement["type"]! as? String
            let last_worn = jsonElement["last_worn"]! as? Date
            let outfit_name = jsonElement["name"]! as? String
            
            outfit.id = id
            outfit.user = userid
            outfit.type = type
            outfit.last_worn = last_worn
            outfit.name = outfit_name
            
            outfits.add(outfit)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: outfits)
            
        })
    }
    
    // Empty Constructor
    override init(){
        
    }
    
    // Constructor with properties
    init(id: Int, user: String, type: String, last_worn: Date, name: String){
        
        self.id = id
        self.user = user
        self.type = type
        self.last_worn = last_worn
        self.name = name
        
    }
    
    // Prints object's current state
    override var description: String{
        return "ID: \(id), User: \(user), Type: \(type), Last Worn: \(last_worn), Name: \(name)"
    }
    
    
    
    
}
