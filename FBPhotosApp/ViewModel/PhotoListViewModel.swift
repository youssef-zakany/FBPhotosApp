//
//  PhotoListViewModel.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import SwiftyJSON

protocol PhotoListViewModelDelegate: class {
    func showProgress()
    func hideProgress()
    func setPhotos(photos: [Photo])
}

struct PhotoListViewModel {
    weak var delegate: PhotoListViewModelDelegate?
    
    init(delegate: PhotoListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchPhotos(albumId: String?){
        if let albumId = albumId, AccessToken.current != nil {
            delegate?.showProgress()
            GraphRequest(graphPath: "\(albumId)/photos", parameters: ["fields":"id,picture"]).start(completionHandler: { (connection, result, error) -> Void in
                self.delegate?.hideProgress()
                
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                    return
                }
                
                guard let result = result else {
                    print("Error:")
                    return
                }
                
                let json = JSON(result)
                var photos = [Photo]()
                
                for data in json["data"].arrayValue {
                    let id = data["id"].stringValue
                    let picture = data["picture"].stringValue
                    let photo = Photo(id: id, picture: picture)
                    photos.append(photo)
                }
                
                self.delegate?.setPhotos(photos: photos)
                
            })
        }
    }
}
