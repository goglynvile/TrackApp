//
//  Track.swift
//  Track App
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 goglynvile. All rights reserved.
//

import UIKit

class Track {
    
    var identifier: Int?
    var name: String?
    var artwork: String?
    var price: Double?
    var currency: String?
    var genre: String?
    var longDescription: String?
    
    var priceString: String? {
        guard let pr = price, let cur = currency else { return nil}
        return String(format: "%@ %.02f", cur, pr)
    }
    
    var identifierString: String {
        if let iden = identifier {
            return "\(iden)"
        }
        return ""
    }
    
    var image: UIImage?
}
