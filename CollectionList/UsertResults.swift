//
//  APIPerson.swift
//  CollectionList
//
//  Created by Florian Cela on 12.11.20.
//

import Foundation

struct UserResults:Decodable {
    let results: [User]
}
struct User: Decodable{
    var name:Name
}
struct Name:Decodable {
    var first:String
    var last:String
}
