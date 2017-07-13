//
//  Controller.swift
//  APITemp
//
//  Created by Rukmani  on 13/07/17.
//  Copyright © 2017 rukmani. All rights reserved.
//
import Alamofire

class Controller {
    
    var delegate: CompletionHandler?
    var labels = [String]()
    func getMovies(completed: @escaping DownloadComplete) {
        let url = StaticURL.movieApi
        Alamofire.request(url).responseJSON { response in
            let value = (response.result.value!)
            if let data = value as? [String: Any] {
                if let feed = data["feed"] as? [String:Any] {
                    if let entries = feed["entry"] as? [Dictionary<String,Any>] {
                        for entry in entries {
                            if let title = entry["title"] as? [String:String]{
                                let label = title["label"]
                                self.labels.append(label!)
                            }
                        }
//                        self.delegate?.onCompletion(list: self.labels)
                    }
                }
            }
            completed(self.labels)
        }
      
    }
}
