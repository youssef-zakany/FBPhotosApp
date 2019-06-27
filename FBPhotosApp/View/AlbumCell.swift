//
//  AlbumCell.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/27/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumCell: UICollectionViewCell {
    
    var album: Album? {
        didSet {
            guard let imageUrl = album?.imageUrl else { return }
            guard let url = URL(string: imageUrl) else { return }
            albumImageView.sd_setImage(with: url)
            albumName.text = album?.name
        }
    }
    
    let albumImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    let albumName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(albumImageView)
        addSubview(albumName)
        albumImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        albumName.anchor(top: albumImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 30))
    }
}
