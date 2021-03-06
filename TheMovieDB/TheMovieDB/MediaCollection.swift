//
//  MediaCollection.swift
//  TheMovieDB
//
//  Created by Luis Ramirez on 2/15/17.
//  Copyright © 2017 Globant. All rights reserved.
//

import UIKit

class MediaCollection : UICollectionView, MyListView {
    weak var myListDelegate: MediaViewControllerDelegate?
    fileprivate var identifier = "MovieCollectionViewCell"
    
    internal func handleDataReload() { self.reloadData() }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    private func configure(){
        let nib = UINib(nibName: identifier, bundle: nil)
        self.dataSource = self
        self.delegate = self
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
}

extension MediaCollection : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myListDelegate?.getNumberOfCells() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        myListDelegate?.setupCell(cell: cell as! MovieCell, indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myListDelegate?.didSelectCell(cell: collectionView.cellForItem(at: indexPath) as! MovieCell,indexPath: indexPath)
    }
}
