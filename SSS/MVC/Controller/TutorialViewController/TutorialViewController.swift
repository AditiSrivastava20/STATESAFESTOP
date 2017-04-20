//
//  TutorialViewController.swift
//  SSS
//
//  Created by Sierra 4 on 15/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    @IBOutlet weak var pageControlTut: UIPageControl!
    
    @IBOutlet weak var btnSkip: UIButton!
    
    
    var arrayImage = [Asset.tut1.image,Asset.tut2.image,Asset.tut3.image]
    var arrayTitle = ["Record the audio and\nvideo and send your location to your safelist","Send your complaints to the\nauthorities without any interference","Manage your contacts\nin the safelist",""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControlTut.currentPage = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        pageControlTut.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
    }
    

    @IBAction func actionBtnSkip(_ sender: Any) {
        
        let vc = StoryboardScene.SignUp.instantiateLogin()
        
        navigationController?.pushViewController(vc, animated: true)
    }
  

}


extension TutorialViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell" , for: indexPath) as? TutorialCollectionViewCell else {return UICollectionViewCell()}
        
        cell.imageViewTut.image = arrayImage[indexPath.row]
        cell.labelTut?.text = arrayTitle[indexPath.row]
        
        return cell
        
        
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var visible = CGRect()
        visible.origin = targetContentOffset.pointee
        visible.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visible.midX, y: visible.midY)
        let visibleIndexPath  = collectionView.indexPathForItem(at: visiblePoint)
        
        if visibleIndexPath![1] == 2 {
            
            self.btnSkip.setTitle("Ready to Go",for: .normal)
            
        } else {
            
            self.btnSkip.setTitle("SKIP",for: .normal)
            
        }
        
    }
    
    
   
    
    
}

extension TutorialViewController  {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height )
    }
    
}
