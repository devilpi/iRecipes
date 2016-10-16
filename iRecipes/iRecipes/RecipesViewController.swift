//
//  FirstViewController.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet weak var chosenFoodTableView: UITableView!
    @IBOutlet weak var recommendFoodTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var suggestButton: UIBarButtonItem!
    
    var chosenFoodList = [Food]() {
        didSet {
            suggestButton.isEnabled = chosenFoodList.count > 0 ? true : false
        }
    }
    var recommendFoodList: [Food]!
    var first = true
    var loaded = false
    var isLoading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
    }
    
    @IBAction func submitRecipes() {
        first = false
        suggestButton.isEnabled = false
        let jsonDict = genDict(for: chosenFoodList, withType: segmentedControl.selectedSegmentIndex)
        if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted]) {
            let url = URL(string: "http://demo101.mybluemix.net/main.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let uploadTask = session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
                if let error = error {
                    print("Failure! \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data, let jsonDict = parse(json: data) {
                        if let foodList = parse(dict: jsonDict) {
                            self.recommendFoodList = foodList
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.loaded = true
                                self.recommendFoodTableView.reloadData()
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
                    self.recommendFoodTableView.reloadData()
                }
            })
            uploadTask.resume()
        }
    }
    
    @IBAction func foodSelectorDidSelectFood(_ segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! FoodSelectorViewController
        chosenFoodList.append(sourceViewController.newFood)
        chosenFoodTableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 100:
            return chosenFoodList.count
        default:
            if loaded {
                return recommendFoodList.count
            } else {
                return first ? 0 : 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch tableView.tag {
        case 100:
            cell = tableView.dequeueReusableCell(withIdentifier: "ChosenFoodCell", for: indexPath)
            let food = chosenFoodList[indexPath.row]
            cell.textLabel!.text = food.name
            cell.detailTextLabel!.text = food.kind
            cell.imageView!.image = #imageLiteral(resourceName: "Placeholder")
            if let imageURL = food.imageURL {
                cell.imageView!.loadImage(url: imageURL)
            }
        default:
            if loaded {
                cell = tableView.dequeueReusableCell(withIdentifier: "RecommendFoodCell", for: indexPath)
                let food = recommendFoodList[indexPath.row]
                cell.textLabel!.text = food.name
                cell.detailTextLabel!.text = food.kind
                cell.imageView!.image = #imageLiteral(resourceName: "Placeholder")
                if let imageURL = food.imageURL {
                    cell.imageView!.loadImage(url: imageURL)
                }
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
                cell.textLabel!.text = isLoading ? "加载中..." : "加载失败，请重试"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 100:
            chosenFoodList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
}
