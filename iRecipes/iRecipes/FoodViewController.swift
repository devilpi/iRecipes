//
//  FoodViewController.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import UIKit

class FoodViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var isLoading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
    }
    var loaded = false
    var foodList: [Food]!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        load(categoryIndex: sender.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoodDetail" {
            let controller = segue.destination as! FoodDetailViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.food = foodList[indexPath.row]
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded {
            return foodList.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if loaded {
            let food = foodList[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
            cell.textLabel!.text = food.name
            cell.detailTextLabel!.text = food.kind
            cell.imageView!.image = #imageLiteral(resourceName: "Placeholder")
            if let imageURL = food.imageURL {
                cell.imageView!.loadImage(url: imageURL)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
            cell.textLabel!.text = isLoading ? "加载中..." : "加载失败，轻触重试"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if !loaded {
            load(categoryIndex: segmentedControl.selectedSegmentIndex)
        }
        return indexPath
    }
    
    func load(categoryIndex: Int = 0) {
        if !isLoading {
            self.isLoading = true
            let url = URL(string: String(format: "http://demo101.mybluemix.net/query.php?category=%d", categoryIndex))!
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                if let error = error {
                    print("Failure! \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data, let jsonDict = parse(json: data) {
                        if let foodList = parse(dict: jsonDict) {
                            self.foodList = foodList
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.loaded = true
                                self.tableView.reloadData()
                            }
                            return
                        }
                    }
                } else {
                    print("Failure! \(response)")
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.loaded = false
                    self.tableView.reloadData()
                }
            })
            dataTask.resume()
        }
    }

}
