//
//  ViewController.swift
//  newcore
//
//  Created by Dhruv Upadhyay on 28/01/20.
//  Copyright © 2020 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController{
    
    
    @IBOutlet var myview: UITableView!
    static let controlHandller = ViewController()
    var myMovies = [Movies]()
    
    
    // @IBOutlet weak var myview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Services.shareInstance.clearData()
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
            if(rData.count > 0)
            {
                self.gettingData()
            }
            else{
                //Services.shareInstance.parsingData()
                Services.shareInstance.parsingData { (flag, error) in
                    if(flag==true){
                        self.gettingData()
                        
                    }
                }
            }
        }
        catch {
            
            print("Failed")
        }
        
        //Services.shareInstance.fetch()
       
        
       }
    
    func gettingData() {
        Services.shareInstance.fetch { (movies, error) in
            if(error==nil){
                self.myMovies = movies!
                DispatchQueue.main.async {
                    self.myview.reloadData()
                }
            }
        }
    }
    
   
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(myMovies.count)
        return self.myMovies.count
        print(self.myMoview.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "india") as! TableViewCell
        cell.lblCollection.text = self.myMovies[indexPath.row].collectionName!
        cell.lblTrack.text = self.myMovies[indexPath.row].trackName!
        let reqUrl = URL(string: self.myMovies[indexPath.row].artworkUrl60!)
        let data = NSData(contentsOf: reqUrl!)
        if data != nil
        {
            cell.myImage.image =  UIImage(data:data! as Data)
        }
        return cell

      
    }
    
}

