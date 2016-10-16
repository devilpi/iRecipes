//
//  FoodDetailViewController.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import UIKit

class FoodDetailViewController: UITableViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var vitaminLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var food: Food!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = food.name
        descriptionLabel.text = food.description
        kindLabel.text = food.kind
        calorieLabel.text = String(format: "%d", food.calorie)
        proteinLabel.text = String(format: "%d", food.protein)
        vitaminLabel.text = String(format: "%d", food.vitamin)
        imageView.frame = CGRect(x: 10, y: 10, width: 350, height: 300)
        imageView.image = #imageLiteral(resourceName: "Placeholder")
        if let imageURL = food.imageURL {
            imageView.loadImage(url: imageURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            return 320
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}
