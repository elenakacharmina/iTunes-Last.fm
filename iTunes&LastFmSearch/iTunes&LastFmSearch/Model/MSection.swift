//
//  MSection.swift
//  iTunes&LastFmSearch
//
//  Created by Elena Kacharmina on 24.02.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation

struct MSection: Decodable, Hashable {
    
    let type: String
    let title: String
    let results: [MItem]
}
