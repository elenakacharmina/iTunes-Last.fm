//
//  SongCell.swift
//  iTunes&LastFmSearch
//
//  Created by Elena Kacharmina on 24.02.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation
import UIKit

class MusicVideoCell: UICollectionViewCell {
    static let reuseId: String = "MusicVideoCell"
    
    let imageView = UIImageView()
    
    let artistNameLabel = UILabel()
    
    let videoNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
        
    }
    
    func setupElements() {
        artistNameLabel.textAlignment = .center
        videoNameLabel.textAlignment = .center
        
        artistNameLabel.font = artistNameLabel.font.withSize(13)
        videoNameLabel.font = videoNameLabel.font.withSize(13)
        
        artistNameLabel.textColor = .systemGray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        videoNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configure(with item: MItem) {
        artistNameLabel.text = item.artistName
        videoNameLabel.text = item.trackName
        
        imageView.downloaded(from: item.linkForImage)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - Setup Constraints
extension MusicVideoCell {
    func setupConstraints() {
        addSubview(imageView)
        addSubview(artistNameLabel)
        addSubview(videoNameLabel)
        
        // imageView constraints
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        // videoNameLabel constraints
        videoNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        videoNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        videoNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        videoNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive  = true
        
        // artistNameLabel constraints
        artistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: videoNameLabel.bottomAnchor).isActive = true
        artistNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive  = true
        
        
    }
}
