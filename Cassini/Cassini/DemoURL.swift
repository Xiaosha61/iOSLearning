//
//  DemoURL.swift
//  Cassini
//
//  Created by Sasa's Macbook on 17/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import Foundation

struct DemoURL {
    static let SchumannBau = "https://upload.wikimedia.org/wikipedia/commons/7/7d/TU-Dresden-Georg-Schumann-Bau.jpg"

    
    static let NASA = [
        "Cassini": "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
        "Earth": "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
        "Saturn": "http://www.nasa.gov/sites/default/files/saturn_collage.jpg"
    ]
    
    static func NASAImageNamed(imageName: String?) -> NSURL? {
        if let urlstring = NASA[imageName ?? ""] {
            return NSURL(string: urlstring)
        } else {
            return nil
        }
    }
    
}
