//
//  MItem.swift
//  iTunes&LastFmSearch
//
//  Created by Elena Kacharmina on 24.02.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation


struct MItem: Decodable, Hashable, Identifiable {
let id = UUID()

private enum CodingKeys : String, CodingKey { case artistName, trackName, kind, linkForImage }
    
    let artistName: String?
    let trackName: String?
    let kind: String?
    let linkForImage: String
}
