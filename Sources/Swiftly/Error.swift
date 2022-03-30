//
//  Error.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

enum SwiftlyError: Error {
    case failedToReadPackages(URL)
    case failedToWritePackages(URL)
    case failedToDecodePackages(Data)
    case failedToEncodePackages([Package])
    case failedToConvertStringToURL(String)
    case failedToCloneRepository(URL, URL)
    case failedToBuildPackage(URL)
    case failedToCreateDirectory(URL)
    case failedToGetContentsOfDirectory(URL)
    case failedToRemoveExecutable(URL)
    case packageAlreadyInstalled(String)
    case packageNotFound(Any)
    case conflictingPackages(Package, [Package])
}
