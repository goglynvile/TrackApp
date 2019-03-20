//
//  TrackTableViewCell.swift
//  Track App
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 goglynvile. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    
    // MARK: - Public variables
    
    /// Update UI when setting a track object
    weak var track: Track? {
        didSet {
            guard let track = track else { return }
            
            self.lblName.text = (track.name != nil) ? track.name : "Not available"
            self.lblPrice.text = track.priceString
            self.lblGenre.text = " \(track.genre ?? "") "
            
            
            guard let url = track.artwork else { return }
            self.imgView.image = UIImage(named: "placeholder")
            
            
                let downloadData = DownloadData(urlString: url) { (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    track.image = data.toImage()
                    OperationQueue.main.addOperation {
                        self.imgView.image = data.toImage()
                    }
                }
                Downloader.shared.startDownload(with: downloadData)
            
        }
    }
    
    // MARK: - Override methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // customize controls
        self.lblGenre.layer.cornerRadius = 5
        self.lblGenre.clipsToBounds = true
    }

}
