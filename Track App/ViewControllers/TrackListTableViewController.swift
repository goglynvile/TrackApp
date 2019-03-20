//
//  MasterViewController.swift
//  Track App
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 goglynvile. All rights reserved.
//

import UIKit

class TrackListTableViewController: UITableViewController {

    // MARK: - Fileprivate variables
    fileprivate var detailViewController: DetailViewController? = nil
    fileprivate var tracks = [Track]()

    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.fetchTracks()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Track List Table View Controller methods
    fileprivate  func fetchTracks() {
        let downloadData = DownloadData(urlString: Constant.serverUrl) { (data, error) in

            guard let data = data?.toJSONDictionary(), let arrTracks = data["results"] as? Array<Dictionary<String, Any>>, error == nil else {
                
                OperationQueue.main.addOperation {
                    Common.showAlertWithMessage(message: error!, to: self)
                }
                return
            }
            
            for track in arrTracks {
                let trackObj = Track()
                
                trackObj.identifier = track["trackId"] as? Int
                trackObj.name = track["trackName"] as? String
                trackObj.price = track["trackPrice"] as? Double
                trackObj.genre = track["primaryGenreName"] as? String
                trackObj.currency = track["currency"] as? String
                trackObj.longDescription = track["longDescription"] as? String
                trackObj.artwork = track["artworkUrl100"] as? String
                
                self.tracks.append(trackObj)
            }
            
            // reload the tableView with fresh data
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
            
            
            // check the last track and select the track
            if let lastTrackIdentifier = Common.getLastTrackIdentifier(), let index = self.tracks.firstIndex(where: {$0.identifier == lastTrackIdentifier}) {
                
                let indexPath = IndexPath(row: index, section: 0)
                OperationQueue.main.addOperation {
                   self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                   self.performSegue(withIdentifier: "showDetail", sender: nil)
                }
            }
        }
        Downloader.shared.startDownload(with: downloadData)
    }


    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let track = tracks[indexPath.row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.track = track
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                // save the last Track Identifier
                Common.saveLastTrackIdentifier(identifier: track.identifier)
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (Common.getLastVisitString() != nil) ? 40 : 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let last = Common.getLastVisitString() else { return nil }
        return "Last visit at \(last)"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTableViewCell
        cell.track = tracks[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
// for saving view state

/*
// MARK: Encoding Protocols
    override func encodeRestorableState(with coder: NSCoder) {
        if let selectedRow = tableView.indexPathForSelectedRow?.row, let trackId = tracks[selectedRow].identifier {
            print("encode: \(trackId)")
            coder.encode(trackId, forKey: Constant.LastValues.selectedTrackId)
        }

        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        let trackId = coder.decodeInteger(forKey: Constant.LastValues.selectedTrackId)
        print("decoded trackId: \(trackId)")

        super.decodeRestorableState(with: coder)
    }

*/
}

/*
extension TrackListTableViewController: UIDataSourceModelAssociation {
    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        guard let index = tracks.firstIndex(where: {$0.identifierString == identifier}) else { return nil }
        self.tableView.reloadData()
        return IndexPath(row: index, section: 0)
    }

    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        let identifier = tracks[idx.row].identifierString
        print("modelIdentifier: \(identifier)")
        return identifier
    }
}
 */

