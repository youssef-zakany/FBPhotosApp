//
//  PhotoListController.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import JGProgressHUD

class PhotoListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    var photos = [Photo]()
    var photoListViewModel: PhotoListViewModel?
    var album: Album?
    
    private let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupPresenter()

    }
    
    func setupNavigationBar() {
        self.title = album?.name
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupPresenter() {
        photoListViewModel = PhotoListViewModel(delegate: self)
        photoListViewModel?.fetchPhotos(albumId: album?.id)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }


}

extension PhotoListController: PhotoListViewModelDelegate {
    func showProgress() {
        hud.textLabel.text = "Loading"
        guard let view = self.navigationController?.view else { return }
        hud.show(in: view)
    }
    
    func hideProgress() {
        hud.dismiss()
    }
    
    func setPhotos(photos: [Photo]) {
        self.photos = photos
        collectionView.reloadData()
    }
}

