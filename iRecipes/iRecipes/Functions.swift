//
//  Functions.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import Foundation

func parse(json data: Data) -> [String: Any]? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
        print("JSON Error: \(error)")
        return nil
    }
}

func parse(dict: [String: Any], search: Bool = false) -> [Food]? {
    if dict["success"] as! Int == 1 {
        var foodList = [Food]()
        if !(search && dict["number"] as! Int == 0) {
            let array = dict["data"] as! [[String: Any]]
            for foodInfo in array {
                let name = foodInfo["name"] as! String
                let description = foodInfo["description"] as! String
                let category = foodInfo["category"] as! String
                let kind = foodInfo["kind"] as! String
                let imageURL = URL(string: foodInfo["imageURL"] as! String)
                let calorie = Int(foodInfo["calorie"] as! String)!
                let protein = Int(foodInfo["protein"] as! String)!
                let vitamin = Int(foodInfo["vitamin"] as! String)!
                let food = Food(name: name, description: description, category: category, kind: kind, imageURL: imageURL, calorie: calorie, protein: protein, vitamin: vitamin)
                foodList.append(food)
            }
        }
        return foodList
    } else {
        return nil
    }
}

func genDict(for food: Food) -> [String: Any] {
    var dict = [String: Any]()
    dict["name"] = food.name
    dict["description"] = food.description
    dict["category"] = food.category
    dict["kind"] = food.kind
    dict["calorie"] = food.calorie
    dict["protein"] = food.protein
    dict["vitamin"] = food.vitamin
    return dict
}

func genDict(for foodList: [Food], withType: Int) -> [String: Any] {
    var array = [String]()
    for food in foodList {
        array.append(food.name)
    }
    return ["type": withType, "data": array]
}
