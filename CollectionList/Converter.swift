//
//  Converter.swift
//  CollectionList
//
//  Created by Florian Cela on 11.11.20.
//
import UIKit
import Foundation

class StringColor{
    class func StringFromUIColor(color: UIColor) -> String {
        let components = color.cgColor.components
        return "[ \(components![0]) , \(components![1]) , \(components![2]) , \(components![3]) ]"
    }
    
    class func UIColorFromString(string: String) -> UIColor {
        var componentsString = string.replacingOccurrences(of: "[", with: "")
        componentsString = string.replacingOccurrences(of: "]", with: "")
        componentsString = string.replacingOccurrences(of: " ", with: "")
        let components = componentsString.components(separatedBy: ",")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                     green: CGFloat((components[1] as NSString).floatValue),
                      blue: CGFloat((components[2] as NSString).floatValue),
                     alpha: CGFloat((components[3] as NSString).floatValue))
    }
}
