//
//  Services.swift
//  newcore
//
//  Created by Dhruv Upadhyay on 29/01/20.
//  Copyright © 2020 Dhruv Upadhyay. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Services : NSObject{
    
    static let shareInstance = Services()
    
    func parsingData(completion: @escaping(Bool?, Error?) -> ()) {
        guard let url = URL(string: "https://itunes.apple.com/search?media=music&term=bollywood") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                if let JSON = jsonResponse as? [String: Any] {
                guard let jsonArray = JSON["results"] as? [[String: Any]] else {
                return}
                    DispatchQueue.main.async {
                        for myData in jsonArray{
                           //print(myData)
                            // Let store into coreData
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                            
                            //We need to create a context from this container
                            let managedContext = appDelegate.persistentContainer.viewContext
                            
                            //Now let’s create an entity and new user records.
                            let userEntity = NSEntityDescription.entity(forEntityName: "MovieData", in: managedContext)!
                                
                                let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                                user.setValue(myData, forKeyPath: "allData")
                                do {
                                try managedContext.save()
                                    completion(true, nil)
                                } catch let error as NSError {
                                print("Could not save. \(error), \(error.userInfo)")
                                    completion(nil,error)
                                    completion(false, nil)
                            }
                        }
                    }
                }
                    
            } catch let parsingError {
                print("Error", parsingError)
                completion(nil,parsingError)
                completion(false, nil)
           }
            
        }
        task.resume()
    }
    
    func clearData() {
      
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData"))
            do {
                try managedContext.execute(DelAllReqVar)
            }
            catch {
                print(error)
            }
    }
    
    
     func fetch(completion: @escaping([Movies]?, String?) -> ()) {
        var rData: [Any] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                rData.append((data.value(forKey: "allData"))! as Any)
                //print(rData)
            }
           
          // print(rData)
           let jsonData = try? JSONSerialization.data(withJSONObject:rData)
           guard let movies = try? JSONDecoder().decode([Movies].self, from: jsonData!) else {
           
             print("Error: Couldn't decode data into cars array")
             //completion(nil)
            return
           }
             print(movies.count)
            completion(movies, nil)
           
           
            
        } catch {
            
            print("Failed")
            completion(nil,"Failed")
        }
        
        
    }
    
}
