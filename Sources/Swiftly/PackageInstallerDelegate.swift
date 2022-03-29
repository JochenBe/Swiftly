//
//  PackageInstallerDelegate.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

protocol PackageInstallerDelegate {
    func willCloneRepository()
    func willBuildPackage()
    func willMoveExecutables()
}
