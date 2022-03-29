//
//  PackageInstaller.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

final class PackageInstaller {
    let url: URL
    var delegate: PackageInstallerDelegate?
    
    init(url: URL, delegate: PackageInstallerDelegate? = nil) {
        self.url = url
        self.delegate = delegate
    }
    
    func resume() throws {
        try swiftly.useDirectory(swiftly.binDirectory)
        
        delegate?.willCloneRepository()
        
        let packageName = url.lastPathComponent
        let packagePath = swiftly.directory.appendingPathComponent(packageName).path
        
        guard Git.clone(from: url, to: packagePath) == 0 else {
            throw SwiftlyError.failedToCloneRepository
        }
        
        defer {
            try? FileManager.default.removeItem(atPath: packagePath)
        }
        
        delegate?.willBuildPackage()
        
        guard Swift.build(path: packagePath) == 0 else {
            throw SwiftlyError.failedToBuildPackage
        }
        
        guard let binURL = URL(string: Swift.getBinPath(path: packagePath)) else {
            throw SwiftlyError.failedToConvertStringToURL
        }
        
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: binURL.path) else {
            throw SwiftlyError.failedToGetContentsOfDirectory
        }
        
        var isDirectory: ObjCBool = false
        let executables = contents.filter { content in
            !content.contains(".")
            &&
            FileManager.default.fileExists(atPath: binURL.appendingPathComponent(content).path, isDirectory: &isDirectory)
            &&
            !isDirectory.boolValue
        }
        
        delegate?.willMoveExecutables()
        
        executables.forEach { executable in
            do {
                try FileManager.default.moveItem(
                    atPath: binURL.appendingPathComponent(executable).path,
                    toPath: swiftly.binDirectory.appendingPathComponent(executable).path
                )
            } catch {
                print(error)
            }
        }
    }
}
