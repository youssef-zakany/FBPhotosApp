//
//  AlbumListViewModel.swift
//  FBAlbumsApp
//
//  Created by YouSS on 6/27/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import SwiftyJSON

protocol AlbumListViewModelDelegate: class {
    func showProgress()
    func hideProgress()
    func setAlbums(albums: [Album])
}

struct AlbumListViewModel {
    weak var delegate: AlbumListViewModelDelegate?
    
    init(delegate: AlbumListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchAlbums(){
        if AccessToken.current != nil {
            delegate?.showProgress()
            GraphRequest(graphPath: "/me/albums", parameters: ["fields":"id,name,picture"]).start(completionHandler: { (connection, result, error) -> Void in
                self.delegate?.hideProgress()
                
                if error != nil {
                    print("An error has occured.")
                    return
                }
                
                guard let result = result else {
                    print("Error: No data.")
                    return
                }

                let json = JSON(result)
                var albums = [Album]()
                
                for data in json["data"].arrayValue {
                    let id = data["id"].stringValue
                    let name = data["name"].stringValue
                    let imageUrl = data["picture"]["data"]["url"].stringValue
                    let album = Album(id: id, name: name, imageUrl: imageUrl)
                    albums.append(album)
                }
                
                albums = albums.sorted(by: {$0.name < $1.name})
                self.delegate?.setAlbums(albums: albums)
            })
        }
    }
}
