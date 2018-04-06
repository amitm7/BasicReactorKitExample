//
//  MovieListing.swift
//  Algorythma
//
//  Created by Amit Mishra on 02/04/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//

import UIKit

class MovieListing: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var sizingCell = CollectionViewCell()
    var dataSource = [MoviesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a
        if ( self.dataSource.count > 0){
            ActionManager.removeNoResult(pageType: .Designer, sourceController: self)}
        else{
            ActionManager.showNoResult(pageType: .Designer, sourceController: self)}
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CollectionViewCell")

        var flowLayout: UICollectionViewFlowLayout {
            let _flowLayout = UICollectionViewFlowLayout()
            
            _flowLayout.itemSize = CGSize(width: self.view.frame.width/2 - 20, height: self.view.frame.width + 100)
            _flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
            _flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
            _flowLayout.minimumInteritemSpacing = 0.0
            
            return _flowLayout
        }
     self.collectionView.collectionViewLayout = flowLayout
    }
    
    // Mark: - Initializing a collectionView and addint it to the VC's
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: layout)
    
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //view.addSubview(collectionView)
    }
    
}

extension MovieListing: UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark: - Specifying the number of sections in the collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Mark: - Specifying the number of cells in given section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let movies = dataSource[indexPath.row]
        let moviewModel = MovieListViewModel(movies)
        return moviewModel.cellInstance(collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       // let stateCell = cell as! CollectionViewCell
       // stateCell.stateCell.text = states[indexPath.row]
        
    }
    
}
