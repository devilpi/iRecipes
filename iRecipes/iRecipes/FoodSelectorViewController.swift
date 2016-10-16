//
//  FoodSelectorViewController.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/16.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import UIKit

class FoodSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newFood: Food!
    var foodList: [Food]!
    var searchText: String?
    var isLoading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
    }
    var loaded = false
    var first = true
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectedFood" {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                newFood = foodList[indexPath.row]
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        first = false
        if !isLoading {
            self.isLoading = true
            let url = URL(string: String(format: "http://demo101.mybluemix.net/search.php?name=", searchBar.text!))!
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                if let error = error {
                    print("Failure! \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data, let jsonDict = parse(json: data) {
                        if let foodList = parse(dict: jsonDict, search: true) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded {
            return foodList.count
        } else {
            return first ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if loaded {
            cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
            let food = foodList[indexPath.row]
            cell.textLabel!.text = food.name
            cell.detailTextLabel!.text = food.kind
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
            cell.textLabel!.text = isLoading ? "加载中..." : "加载失败，请重试"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return loaded ? indexPath : nil
    }
    
}
