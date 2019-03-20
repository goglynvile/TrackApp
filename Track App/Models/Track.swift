//
//  Track.swift
//  Track App
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 goglynvile. All rights reserved.
//

import UIKit

/// A model class from JSON value.
class Track {
    
    // MARK: - Public variables
    var identifier: Int?
    var name: String?
    var artwork: String?
    var price: Double?
    var currency: String?
    var genre: String?
    var longDescription: String?
    
    var image: UIImage?
    
    /// Price string value to display
    var priceString: String? {
        guard let pr = price, let cur = currency else { return nil}
        return String(format: "%@ %.02f", cur, pr)
    }
}
