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
        try Swiftly.useDirectory(Swiftly.binDirectory)
        
        delegate?.willCloneRepository()
        
        let packageName = url.lastPathComponent
        let packagePath = Swiftly.directory.appendingPathComponent(packageName).path
        
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
        
        let binURL = URL(fileURLWithPath: Swift.getBinPath(path: packagePath))
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
        
        let conflictingPackages = try Packages.get(by: Set(executables))
        guard conflictingPackages.allSatisfy({ p in
            p.url == url
        }) else {
            throw SwiftlyError.conflictingPackages
        }
        
        let package = Package(url: url, executables: executables)
        try Packages.add(package)
        
        delegate?.willMoveExecutables()
        
        executables.forEach { executable in
            do {
                let _ = try FileManager.default.replaceItemAt(
                    Swiftly.binDirectory.appendingPathComponent(executable),
                    withItemAt: binURL.appendingPathComponent(executable)
                )
            } catch {
                print(error)
            }
        }
    }
}
