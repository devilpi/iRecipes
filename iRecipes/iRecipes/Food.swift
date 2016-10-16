//
//  Food.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import Foundation

class Food {
    
    let name: String
    let description: String
    let category: String
    let kind: String
    let imageURL: URL?
    let calorie: Int
    let protein: Int
    let vitamin: Int
    
    init(name: String, description: String, category: String, kind: String, imageURL: URL?, calorie: Int, protein: Int, vitamin: Int) {
        self.name = name
        self.description = description
        self.category = category
        self.kind = kind
        self.imageURL = imageURL
        self.calorie = calorie
        self.protein = protein
        self.vitamin = vitamin
    }
    
}
