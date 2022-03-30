//
//  Error.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

enum SwiftlyError: Error {
    case failedToReadPackages
    case failedToWritePackages
    case failedToDecodePackages
    case failedToEncodePackages
    case failedToCreateDirectory
    case failedToGetContentsOfDirectory
    case failedToConvertStringToURL
    case failedToCloneRepository
    case failedToBuildPackage
    case failedToRemoveExecutable
    case conflictingPackages
    case packageNotFound
}
