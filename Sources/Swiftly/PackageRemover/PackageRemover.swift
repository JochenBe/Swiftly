//
//  PackageRemover.swift
//  
//
//  Created by Jochen Bernard on 30/03/2022.
//

import Foundation

final class PackageRemover {
    let package: Package
    var delegate: PackageRemoverDelegate?
    
    init(package: Package, delegate: PackageRemoverDelegate? = nil) {
        self.package = package
        self.delegate = delegate
    }
    
    func resume() throws {
        delegate?.willRemoveExecutables()
        
        for executable in package.executables {
            let executablePath = Swiftly.binDirectory.appendingPathComponent(executable)
            
            do {
                try FileManager.default.removeItem(at: executablePath)
            } catch {
                throw SwiftlyError.failedToRemoveExecutable(executablePath)
            }
        }
        
        try Packages.remove(package)
    }
}
