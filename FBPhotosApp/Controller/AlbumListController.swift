//
//  AlbumListController.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/27/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import JGProgressHUD
import FBSDKLoginKit

class AlbumListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    var albums = [Album]()
    var albumListViewModel: AlbumListViewModel?
    private let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupPresenter()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavigationBar() {
        self.title = "Albums"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: cellId)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    func setupPresenter() {
        albumListViewModel = AlbumListViewModel(delegate: self)
        albumListViewModel?.fetchAlbums()
    }
    
    @objc fileprivate func handleLogout() {
        FacebookManager.shared.SignOut()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 24) / 2 
        return CGSize(width: width, height: width + 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AlbumCell
        cell.album = albums[indexPath.item]
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        let photoListController = PhotoListController(collectionViewLayout: UICollectionViewFlowLayout())
        photoListController.album = album
        navigationController?.pushViewController(photoListController, animated: true)
    }
}
    
extension AlbumListController: AlbumListViewModelDelegate {
    func showProgress() {
        hud.textLabel.text = "Loading"
        guard let view = self.navigationController?.view else { return }
        hud.show(in: view)
    }
    
    func hideProgress() {
        hud.dismiss()
    }
    
    func setAlbums(albums: [Album]) {
        self.albums = albums
        collectionView.reloadData()
    }
}
    


