//
//  Swiftly+Remove.swift
//
//
//  Created by Jochen Bernard on 30/03/2022.
//

import ArgumentParser
import Foundation

extension Swiftly {
    struct Remove: ParsableCommand, PackageRemoverDelegate {
        @Argument(help: "The package to remove.")
        var package: String
        
        func run() throws {
            try Swiftly.useDirectory(Swiftly.binDirectory)
            
            guard let package = try Packages.get(by: package) else {
                throw SwiftlyError.packageNotFound(package)
            }
            
            let packageRemover = PackageRemover(package: package, delegate: self)
            try packageRemover.resume()
        }
        
        func willRemoveExecutables() {
            print(Colors.cyan("Removing executables..."))
        }
    }
}
