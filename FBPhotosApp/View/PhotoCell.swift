//
//  PhotoCell.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    var photo: Photo? {
        didSet {
            guard let imageUrl = photo?.picture else { return }
            guard let url = URL(string: imageUrl) else { return }
            photoImageView.sd_setImage(with: url)
        }
    }
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
}
