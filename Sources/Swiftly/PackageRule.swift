//
//  PackageRule.swift
//  
//
//  Created by Jochen Bernard on 31/03/2022.
//

enum PackageRule: Codable {
    case major(String)
    case minor(String)
    case range(String, String)
    case version(String)
    case branch(String)
    case commit(String)
}
