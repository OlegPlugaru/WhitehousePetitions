//
//  ViewController.swift
//  WhitehousePetition
//
//  Created by Oleg Plugaru on 01.10.2023.
//

import UIKit
import SwiftyJSON

class ViewController: UITableViewController {
    
    var objects = [[String: String]]()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString: String
        
        if (navigationController?.tabBarItem.tag == 0) {
           urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let json = try? JSON(data: data)
                    
                    if json?["metadata"]["responseInfo"]["status"].intValue == 200 {
                        self.parseJSON(json: json ?? "")
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
                }
            } else {
                self.showError()
            }
        }
    }
        
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; Please check your conetction and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
        func parseJSON(json: JSON) {
            for result in json["results"].arrayValue {
                let title = result["title"].stringValue
                let body = result["body"].stringValue
                let sigs = result["signatureCount"].stringValue
                
                let dict = ["title": title, "body": body, "sigs": sigs]
                objects.append(dict)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                    (segue.destination as! DetailViewController).detailItem = object

            }
        }
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }
}

