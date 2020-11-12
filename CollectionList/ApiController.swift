//
//  ApiController.swift
//  CollectionList
//
//  Created by Florian Cela on 12.11.20.
//

import Foundation

class ApiController{
    
    static func downloadJSON( completion: @escaping ([User]) -> ()){
        let url = URL(string: "https://randomuser.me/api/?format=json&results=50")
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error == nil {
                do {
                    let newUser = try JSONDecoder().decode(UserResults.self, from: data!)
                    
                    DispatchQueue.main.async {
                        completion(newUser.results)
                    }
                }catch{
                    print("JSON Error")
                }
            }
        }.resume()
    }
}
