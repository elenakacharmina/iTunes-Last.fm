//
//  SectionHeader.swift
//  iTunes&LastFmSearch
//
//  Created by Elena Kacharmina on 05.03.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let reuseId = "SectionHeader"
    
    let title = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customizedElements()
        setuoConsrtaints()
    }
    
    
    private func customizedElements() {
        title.textColor = .black
        title.font = UIFont(name: "avenir", size: 20)
        title.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setuoConsrtaints() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
