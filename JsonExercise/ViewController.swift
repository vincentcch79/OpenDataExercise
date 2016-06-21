//
//  ViewController.swift
//  JsonExercise
//
//  Created by 張智涵 on 2016/6/21.
//  Copyright © 2016年 張智涵 Vincent Chang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage 


class ViewController: UIViewController {
    
    @IBOutlet weak var TableViewHotelList: UITableView!
    
    
    var schoolArray = [schools]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewHotelList.dataSource = self
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadData(sender: AnyObject) {
        
        let urlString = "http://data.taipei/opendata/datalist/apiAccess"
        
        Alamofire.request(.GET, urlString, parameters: ["scope": "resourceAquire", "rid": "11f11d42-bdd8-45d0-9493-8134b2e494e9", "offset": "10", "limit": "8"])
            .responseJSON {
                response in
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    let schoolList = json["result"]["results"].arrayValue
                    
                    for schoolJson in schoolList {
//                        print("school name: \(schoolJson["o_tlc_agency_name"].stringValue)")
//                        print("school address: \(schoolJson["o_tlc_agency_address"].stringValue)")
//                        print("school type: \(schoolJson["o_tlc_agency_categorychild"].stringValue)")
                        
                        
                        let names = schoolJson["o_tlc_agency_name"].stringValue
                        let address = schoolJson["o_tlc_agency_address"].stringValue
                        let category = schoolJson["o_tlc_agency_categorychild"].stringValue
                        let image = schoolJson["o_tlc_agency_img_front"].stringValue
                        let school = schools(names: names, address: address, category: category, image: image)
                        
                        self.schoolArray.append(school)
//                        print("name: \(self.schoolArray)")
                        self.TableViewHotelList.reloadData()
                    }
                    
                    
                }
        }
     
    }
}

    extension ViewController: UITableViewDataSource {
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return schoolArray.count
        }
        
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
           
            
            cell.textLabel?.text = schoolArray[indexPath.row].names
            cell.detailTextLabel?.text = schoolArray[indexPath.row].address
            
            let url = NSURL(string: schoolArray[indexPath.row].image!)
            
            cell.imageView?.sd_setImageWithURL(url, placeholderImage: nil)
            cell.imageView?.contentMode = .ScaleAspectFit
            
            
            return cell
        }
        
    }
    
    



