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
    
    init(package: Package, delegate: PackageInstallerDelegate? = nil) {
        self.url = package.url
        self.delegate = delegate
    }
    
    func resume() throws {        
        delegate?.willCloneRepository()
        
        let packageName = url.lastPathComponent
        let packageURL = Swiftly.directory.appendingPathComponent(packageName)
        
        guard Git.clone(from: url, to: packageURL.path) == 0 else {
            throw SwiftlyError.failedToCloneRepository(url, packageURL)
        }
        
        defer {
            try? FileManager.default.removeItem(atPath: packageURL.path)
        }
        
        delegate?.willBuildPackage()
        
        guard Swift.build(path: packageURL.path) == 0 else {
            throw SwiftlyError.failedToBuildPackage(packageURL)
        }
        
        let binURL = URL(fileURLWithPath: Swift.getBinPath(path: packageURL.path))
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: binURL.path) else {
            throw SwiftlyError.failedToGetContentsOfDirectory(binURL)
        }
        
        var isDirectory: ObjCBool = false
        let executables = contents.filter { content in
            !content.contains(".")
            &&
            FileManager.default.fileExists(atPath: binURL.appendingPathComponent(content).path, isDirectory: &isDirectory)
            &&
            !isDirectory.boolValue
        }
        
        let package = Package(url: url, executables: executables)
        let conflictingPackages = try Packages.getConflictingPackages(for: package)
        
        guard conflictingPackages.count == 0 else {
            throw SwiftlyError.conflictingPackages(package, conflictingPackages)
        }
        
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
