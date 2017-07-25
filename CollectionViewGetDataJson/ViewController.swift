//
//  ViewController.swift
//  CollectionViewGetDataJson
//
//  Created by QTS Coder on 7/24/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var arrayTemp = [Youtube]()
    var playerViewController:AVPlayerViewController!
    
    var arraySong:[String] = ["Taylor Swift - I Knew You Were Trouble","RIHANNA - Work (Explicit) ft  Drake (Our Version)","Beyoncé - Single Ladies (Put a Ring on It)","Kanye West's heartless rant against Taylor Swift","Rebecca Black - Friday","John Legend - All of Me"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerViewController = AVPlayerViewController()

        navigationItem.title = "Home"
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        Youtube.loadDataYoutube { (results) in
            for result in results!
            {
                self.arrayTemp.append(result)
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }
            
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
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
        
        if second > 9
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let path = Bundle.main.path(forResource: arraySong[indexPath.row], ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        playerViewController.player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
        present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }

    }
    
    
}
