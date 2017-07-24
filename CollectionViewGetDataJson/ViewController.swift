//
//  ViewController.swift
//  CollectionViewGetDataJson
//
//  Created by QTS Coder on 7/24/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var arrayTemp = [Youtube]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(9%4)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        Youtube.loadDataYoutube { (results) in
            for result in results!
            {
                print(result)
                self.arrayTemp.append(result)
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }
            
        }
        
        
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTemp.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        cell.backgroundColor = UIColor.white
        
        let youtubeObject = arrayTemp[indexPath.row]
        let second = (youtubeObject.duration) % 60
        let minute = (youtubeObject.duration - second) / 60
       
        cell.profile_image_name.layer.cornerRadius = cell.profile_image_name.frame.size.height / 2
        
        cell.thumbnail_image_name.loadImage(imagelink: youtubeObject.thumbnail_image_name)
        cell.title.text = youtubeObject.title
        cell.profile_image_name.loadImage(imagelink: youtubeObject.channel["profile_image_name"] as! String)
        cell.nameandNumberofView.text = "\(youtubeObject.channel["name"] as! String) channel      \(youtubeObject.number_of_views) views"
        
        if second > 10
        {
            cell.duration.text = "\(minute):\(second)"
        }
        else
        {
            cell.duration.text = "\(minute):0\(second)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 310)
    }
    
}
