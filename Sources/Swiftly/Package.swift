//
//  Package.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

struct Package: Codable {
    let url: URL
    let executables: [String]
}
