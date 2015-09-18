//
//  APIController.swift
//  HelloWorld_0
//
//  Created by intern02 on 2015/09/10.
//  Copyright (c) 2015年 intern02. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSArray)
}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol){
        self.delegate = delegate
    }
    
    func get(path: String){
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil){
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary{
                if(err != nil){
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let results: NSArray = jsonResult["results"] as? NSArray{
                    self.delegate.didRecieveAPIResults(results)
                }
            }
        })
        task.resume()
    }
    
    func searchItunesFor(searchTerm: String){
        //探索文字列の形式を変換、空間をプラスに変換
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        //リクエスト
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }
    
    func lookupAlbum(collectionId: Int){
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
}

