//
//  KindPickerViewController.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import UIKit

class KindPickerViewController: UITableViewController {
    
    var selectedCategoryName: String!
    var selectedKindName: String!
    var selectedIndexPath = IndexPath()
    let kinds = [["主食", "谷物", "面食"],
                 ["蔬果", "蔬菜", "水果"],
                 ["肉类", "禽畜肉", "海鲜"],
                 ["蛋奶", "蛋", "奶", "豆"],
                 ["其他", "其他"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<kinds.count {
            for j in 1..<kinds[i].count {
                if kinds[i][j] == selectedKindName {
                    selectedIndexPath = IndexPath(row: j - 1, section: i)
                    break
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickedKind" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectedCategoryName = kinds[indexPath.section][0]
                selectedKindName = kinds[indexPath.section][indexPath.row + 1]
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return kinds.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kinds[section][0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kinds[section].count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KindCell", for: indexPath)
        let kindName = kinds[indexPath.section][indexPath.row + 1]
        cell.textLabel!.text = kindName
        if kindName == selectedKindName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != selectedIndexPath {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
                oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
        }
    }
    
}
