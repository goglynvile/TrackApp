//
//  Common.swift
//  Track App
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 goglynvile. All rights reserved.
//

import UIKit


/// A class that contains common methods to be used all through out the app.
class Common {
    
    /// Show alert message.
    class func showAlertWithMessage(message: String, to viewController: UIViewController) {
        let alert = UIAlertController(title: Constant.appTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Save the current date.
    class func saveLastVisit() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: Constant.LastValues.dateVisited)
    }
    
    /// Get the last visit date string value.
    class func getLastVisitString() -> String? {
        guard let date = UserDefaults.standard.value(forKey: Constant.LastValues.dateVisited) as? Date else {
            return nil
        }
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMM dd, yyyy HH:mm"
        
        return formatter.string(from: date)
    }
    
    /// Save the last identifier.
    class func saveLastTrackIdentifier(identifier: Int?) {
        UserDefaults.standard.set(identifier, forKey: Constant.LastValues.selectedTrackId)
    }
    
    /// Get the last identifier.
    class func getLastTrackIdentifier() -> Int? {
        return UserDefaults.standard.value(forKey: Constant.LastValues.selectedTrackId) as? Int
    }
}
