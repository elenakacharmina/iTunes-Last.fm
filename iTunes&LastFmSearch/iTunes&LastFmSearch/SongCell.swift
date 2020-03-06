//
//  SongCell.swift
//  iTunes&LastFmSearch
//
//  Created by Elena Kacharmina on 24.02.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation
import UIKit

class SongCell: UICollectionViewCell {
    static let reuseId: String = "SongCell"
    
    let imageView = UIImageView()
    
    let artistNameLabel = UILabel()
    
    let songLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)
        setupElements()
        setupConstraints()
        
    }
    
    func setupElements() {
        artistNameLabel.font = artistNameLabel.font.withSize(13)
        artistNameLabel.textColor = .gray
        
        
        songLabel.font = songLabel.font.withSize(13)
        
        
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configure(with item: MItem) {
        artistNameLabel.text = item.artistName
        songLabel.text = item.trackName
        imageView.downloaded(from: item.linkForImage)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - Setup Constraints
extension SongCell {
    func setupConstraints() {
        addSubview(imageView)
        addSubview(artistNameLabel)
        addSubview(songLabel)
        
        // imageView constraints
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // artistNameLabel constraints
        artistNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        artistNameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -2).isActive = true
        artistNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive  = true
        
        // songLabel constraints
        songLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        songLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        songLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        songLabel.heightAnchor.constraint(equalToConstant: 18).isActive  = true
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
