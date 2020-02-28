//
//  Networking.swift
//  ImageGet
//
//  Created by arsik on 24.02.2020.
//  Copyright © 2020 arsik. All rights reserved.
//

import Foundation


class NetworkManager {
  static func getRequest(url: String){
      guard let url = URL(string: url) else { return}
      
      let session = URLSession.shared
      
      session.dataTask(with: url) { (data, response, error) in
        if let response = response{
          print(response)
        }
        
        guard let data = data else {return}
        
        print(data)
        
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: [])
          print(json)
        } catch {
          print(error)
        }
      } .resume()
    }
  
  
  static func postRequest(url: String){
  guard let url = URL(string: url) else { return }
      
      let userData = ["Course": "Networking" , "Lesson": "Get Request"]
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
     
     guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
     request.httpBody = httpBody 
     
      let session = URLSession.shared
     
     session.dataTask(with: request) { (data, response, error) in
       guard let data = data,
             let response = response
         else { return }
       print(response)
       
       do {
         let json = try JSONSerialization.jsonObject(with: data, options: [])
         print(json)
       } catch {
         print(error)
       }
     }.resume()
  }
  
  static func getImage(url: String , completion: @escaping(_ imageData: Data?)->()) {
      guard let url = URL(string: url) else {
        completion(nil)
        return
    }
      completion(try? Data(contentsOf: url))
     /*
     session.dataTask(with: url) { (data, response, error) in
       if let data = data , let image = UIImage(data: data) {
         DispatchQueue.main.async {
          completion(image)
         }
       }
    }.resume()*/
  }
  
  
  static func feachData(url: String ,  comletion: @escaping(_ course: [ModelUsers])->()){

   guard let url = URL(string: url)  else { return }
    
    URLSession.shared.dataTask(with: url) { (data, _, _) in
      guard let data = data else { return }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let course = try decoder.decode([ModelUsers].self, from: data)
        comletion(course)
      }catch let error {
        print("Возникла ошибка ", error)
      }
    }.resume()
  }
}
