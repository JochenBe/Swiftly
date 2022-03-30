//
//  PackageRemover.swift
//  
//
//  Created by Jochen Bernard on 30/03/2022.
//

import Foundation

final class PackageRemover {
    let url: URL
    var delegate: PackageRemoverDelegate?
    
    init(url: URL, delegate: PackageRemoverDelegate? = nil) {
        self.url = url
        self.delegate = delegate
    }
    
    func resume() throws {
        guard let package = try Packages.get(by: url) else {
            throw SwiftlyError.packageNotFound
        }
        
        delegate?.willRemoveExecutables()
        
        for executable in package.executables {
            do {
                try FileManager.default.removeItem(at: Swiftly.binDirectory.appendingPathComponent(executable))
            } catch {
                throw SwiftlyError.failedToRemoveExecutable
            }
        }
        
        try Packages.remove(package)
    }
}
