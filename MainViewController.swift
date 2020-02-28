//
//  MainViewController.swift
//  ImageGet
//
//  Created by arsik on 08.02.2020.
//  Copyright © 2020 arsik. All rights reserved.
//

import UIKit



class MainViewController: UIViewController {
  

  @IBOutlet var tableView: UITableView!
  
  private let urlCourse = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
  private var courses = [ModelUsers]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
 
      title = "Course"
      feachData()
      
  }
  
  //MARK: Конфигурация ячейки
  private func configurationCell(cell: MainCell, for indexPath: IndexPath) {
    let jsonModel = courses[indexPath.row]
    
    cell.nameCourse.text = jsonModel.name

    if let numbderOfLessons = jsonModel.numberOfLessons {
      cell.numberOfLessons.text = String(numbderOfLessons)
  }
    
    if let numberOfTests = jsonModel.numberOfTests {
      cell.numberOfTests.text = String(numberOfTests)
    }
    
    DispatchQueue.global().async {
        guard let imagesUrl = URL(string: jsonModel.imageUrl) else { return }
        guard let imageData = try? Data(contentsOf: imagesUrl) else { return }
     
      DispatchQueue.main.async {
      cell.imageMain.image = UIImage(data: imageData)
     }
   }
  }
  
  func feachData() {
    NetworkManager.feachData(url: urlCourse) { (courses) in
      self.courses = courses
      DispatchQueue.main.async {
         self.tableView.reloadData()
      }
    }
  }
}

extension MainViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return courses.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainCell
    configurationCell(cell: cell, for: indexPath)
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

