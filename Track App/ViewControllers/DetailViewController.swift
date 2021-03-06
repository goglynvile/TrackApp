//
//  DetailViewController.swift
//  Track App
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 goglynvile. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgInfo: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - Public variables
    var track: Track? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        setupUI()
        
    }

    // MARK: - Fileprivate methods
    
    /// Configure the view when user selects from master list.
    fileprivate func configureView() {
        // Update the user interface for the detail item.
        if let track = track {
            if txtDescription != nil {
                txtDescription.text = ( track.longDescription != nil ) ? track.longDescription : "No description available."
            }
            if lblTitle != nil {
                lblTitle.text = track.name
            }
            
            if imgBackground != nil {
                imgBackground.image = track.image
                imgInfo.image = track.image
            }
        }
    }
    
    /// Customize the UI controls
    fileprivate func setupUI() {
        lblTitle.textColor = UIColor.white
        imgInfo.layer.borderColor = UIColor.white.cgColor
        imgInfo.layer.borderWidth = 5
        
        viewContainer.layer.cornerRadius = 20
        viewContainer.clipsToBounds = true
    }

}

