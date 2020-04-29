//
//  Utilities.swift
//  ChatChat0
//
//  Created by Sebastian Figueroa on 26/04/17.
//  Copyright © 2017 Sebastian Figueroa. All rights reserved.
//

import Foundation
import UIKit


class Utilities {

    func ShowAlert(title:String, message: String, vc: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)

    }
    
    func GetDate () -> String{
    
        let today = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyy HH:mm"
        
        return dateFormatter.string(from: today)
    
    }
    
}
