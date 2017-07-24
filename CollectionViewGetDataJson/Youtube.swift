//
//  Youtube.swift
//  CollectionViewGetDataJson
//
//  Created by QTS Coder on 7/24/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import UIKit

struct Youtube {
    
    let title: String?
    let number_of_views: Double
    let thumbnail_image_name: String
    let duration: Int
    var channel: [String: AnyObject]
    
    enum SerizalitionError: Error {
        case missing(String)
        case invalid(String)
    }
    
    init(myJson: [String: AnyObject]) throws {
        
        guard let title = myJson["title"] as? String else { throw SerizalitionError.missing("missing title")}
        guard let number_of_views = myJson["number_of_views"] as? Double else { throw SerizalitionError.missing("missing number_of_views")}
        guard let thumbnail_image_name = myJson["thumbnail_image_name"] as? String else { throw SerizalitionError.missing("missing thumbnail_image_name")}
        guard let duration = myJson["duration"] as? Int else { throw SerizalitionError.missing("missing duration")}
        guard let channel = myJson["channel"] as? [String: AnyObject] else { throw SerizalitionError.missing("missing channel")}
        
        
        self.title = title
        self.number_of_views = number_of_views
        self.thumbnail_image_name = thumbnail_image_name
        self.duration = duration
        self.channel = channel
        
    }
    
    static func loadDataYoutube(completion: @escaping ([Youtube]?) -> ())
    {
        let url = URL(string: "https://api.myjson.com/bins/fgpmn")
        if url != nil
        {
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, respone, error) in
                
                var arrayYoutube = [Youtube]()
                
                if error != nil
                {
                    print(error!)
                }
                else
                {
                    if let content =  data {
                        do {
                            let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! Array<[String: AnyObject]>
                            
                            for point in myJson
                            {
                                if let youtubeObject = try? Youtube(myJson: point)
                                {
                                    arrayYoutube.append(youtubeObject)
                                }
                            }
                            
                        } catch
                        {
                            
                        }
                        
                        completion(arrayYoutube)
                    }
                }
            })
            task.resume()
        }
    }
    
}

extension UIImageView
{
func loadImage(imagelink: String)
{
    let queue = DispatchQueue(label: "loadImage", qos: .default, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activity.color = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    activity.center = self.center
    activity.startAnimating()
    self.addSubview(activity)
    
    queue.async {
        let url = URL(string: imagelink)
        do {
            let data = try Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                activity.stopAnimating()
            }
            
        }catch
        {
            print("Loi")
        }

    }
    
    }
}








