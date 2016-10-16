//
//  AddFoodViewController.swift
//  iRecipes
//
//  Created by 朱子秋 on 2016/10/15.
//  Copyright © 2016年 朱子秋. All rights reserved.
//

import UIKit

class AddFoodViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var vitaminLabel: UILabel!
    
    var name = ""
    var foodDescription = ""
    var category = "其他"
    var kind = "其他"
    var calorie = 1 {
        didSet {
            calorieLabel.text = String(format: "%d", calorie)
        }
    }
    var protein = 1 {
        didSet {
            proteinLabel.text = String(format: "%d", protein)
        }
    }
    var vitamin = 1 {
        didSet {
            vitaminLabel.text = String(format: "%d", vitamin)
        }
    }
    var isLoading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
    }
    
    @IBAction func kindPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! KindPickerViewController
        category = controller.selectedCategoryName
        kind = controller.selectedKindName
        kindLabel.text = kind
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        if !isLoading {
            let uploadingHud = HudView.hud(inView: navigationController!.view, animated: true, withText: "正在上传")
            let food = Food(name: name, description: foodDescription, category: category, kind: kind, imageURL: nil, calorie: calorie, protein: protein, vitamin: vitamin)
            let jsonDict = genDict(for: food)
            if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted]) {
                let url = URL(string: "http://demo101.mybluemix.net")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let session = URLSession.shared
                let uploadTask = session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
                    if let error = error {
                        print("Failure! \(error)")
                    } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        if let data = data, let jsonDict = parse(json: data) {
                            if jsonDict["success"] as! Int == 1 {
                                DispatchQueue.main.async {
                                    self.isLoading = false
                                    uploadingHud.removeFromSuperview()
                                    let _ = HudView.hud(inView: self.navigationController!.view, animated: true, withText: "上传成功", andImage: #imageLiteral(resourceName: "Success"))
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                return
                            }
                        }
                    } else {
                        print("Failure! \(response)")
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                        uploadingHud.removeFromSuperview()
                        let failHud = HudView.hud(inView: self.navigationController!.view, animated: true, withText: "上传失败", andImage: #imageLiteral(resourceName: "Fail"))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            failHud.superview!.isUserInteractionEnabled = true
                            failHud.removeFromSuperview()
                        }
                    }
                })
                uploadTask.resume()
            }
        }
    }
    
    @IBAction func calorieSliderMoved(_ sender: UISlider) {
        calorie = lroundf(sender.value)
    }
    
    @IBAction func proteinSliderMoved(_ sender: UISlider) {
        protein = lroundf(sender.value)
    }
    
    @IBAction func vitaminSliderMoved(_ sender: UISlider) {
        vitamin = lroundf(sender.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickKind" {
            let controller = segue.destination as! KindPickerViewController
            controller.selectedKindName = kind
        }
    }
    
}
