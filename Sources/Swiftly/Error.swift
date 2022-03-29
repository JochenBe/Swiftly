//
//  Error.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

enum SwiftlyError: Error {
    case failedToConvertArgumentToURL
    case failedToInitializeBinURL
    case failedToCreateSwiftlyDirectory
    case failedToCloneRepository
    case failedToBuildPackage
    case failedToGetContentsOfBinPath
    case failedToConvertBinPathToURL
}
