//
//  Downloader.swift
//  Downloader
//
//  Created by Glynvile Satago on 19/03/2019.
//  Copyright © 2019 Glynvile Satago. All rights reserved.
//

import Foundation
import UIKit

/// 'Downloader' is an easy to use library in downloading any type of files.
open class Downloader {
    
    /// A singleton object that will be returned everytime Downloader is used.
    public static let shared = Downloader()
    
    /// Initialize the OperationQueue
    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "OperationQueue.downloadManager"
        operationQueue.maxConcurrentOperationCount = 10
        return operationQueue
    }()
    
    
    /// Sets the size in MB of the shared URLCache
    ///
    /// - Parameters:
    ///  - sizeInMb: An int to set
    open class func setCacheSizeInMb(sizeInMb: Int) {
        let urlCache = URLCache(memoryCapacity: sizeInMb * 1024 * 1024, diskCapacity: sizeInMb * 1024 * 1024, diskPath: nil)
        URLCache.shared = urlCache
    }
    
    // Mark: - Downloader operation methods
    
    /// Starts the download of the data. Adds 'DownloadData' to the OperationQueue.
    ///
    /// - Parameters:
    ///  - downloadData: A 'DownloadData' to be downloaded.
    open func startDownload(with downloadData: DownloadData) {
        let operation = BlockOperation {
            downloadData.start()
        }
        operation.name = downloadData.urlString
        operationQueue.addOperation(operation)
    }
    
    /// Starts the download of the array of data. Adds array of 'DownloadData' to the OperationQueue.
    ///
    /// - Parameters:
    ///  - downloadDataArray: An 'DownloadData' array to be downloaded.
    open func startDownloads(with downloadDataArray: [DownloadData]) {
        for downloadData in downloadDataArray {
            let operation = BlockOperation {
                downloadData.start()
            }
            operation.name = downloadData.urlString
            operationQueue.addOperation(operation)
        }
    }
}

/// An extension to Data
public typealias DownloadedData = Data
public extension DownloadedData {

    // MARK: - Declaration of typealias
    typealias ReadableImage = UIImage
    typealias ReadableJSONDictionary = Dictionary<String, Any>
    
    // MARK: - Data to Readable format methods
    
    /// Returns the image object from reading the data.
    ///
    /// - Returns: A 'ReadableImage' converted from 'DownloadedData'
    func toImage() -> ReadableImage? {
        let image = UIImage(data: self)
        return image
    }
    
    /// Returns the JSON dictionary object from reading the data.
    ///
    /// - Returns: A 'ReadableJSONDictionary' converted from 'DownloadedData'
    func toJSONDictionary() -> ReadableJSONDictionary? {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: self, options: [])
            return jsonResponse as? Dictionary<String, Any>
        }
        catch {
            return nil
        }
        
    }
}

/// A class that manages the data to be downloaded.
public class DownloadData {
    
    // MARK: fileprivate properties
    fileprivate let urlString: String
    fileprivate var dataTask: URLSessionDataTask!
    
    // MARK: public properties
    public typealias completion = ((DownloadedData?, String?) -> Void)
    public var completionHandler: completion

    // MARK: Initializer methods
    public init(urlString: String, completionHandler: @escaping completion) {
        self.urlString = urlString
        self.completionHandler = completionHandler
    }

    // MARK: fileprivate methods

    /// Execute the download. Instantiate the 'dataTask' and begin the download.
    fileprivate func start() {
        
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        if self.dataTask == nil {
            self.dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in

                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        self.completionHandler(nil, error?.localizedDescription )
                        return }

                
                self.completionHandler(dataResponse, nil)
            })
        }
        
        self.dataTask.resume()
    }
}


