//
//  Swiftly+Update.swift
//  
//
//  Created by Jochen Bernard on 30/03/2022.
//

import ArgumentParser
import Foundation

extension Swiftly {
    struct Update: ParsableCommand, PackageInstallerDelegate {
        @OptionGroup var options: Options
        
        func run() throws {
            guard let url = URL(string: options.url) else {
                throw SwiftlyError.failedToConvertStringToURL(options.url)
            }
            
            try Swiftly.useDirectory(Swiftly.binDirectory)
            
            guard try Packages.get(by: url) != nil else {
                throw SwiftlyError.packageNotFound(url)
            }
            
            let packageInstaller = PackageInstaller(url: url, delegate: self)
            try packageInstaller.resume()
        }
        
        func willCloneRepository() {
            print(Colors.cyan("Cloning repository...\n"))
        }
        
        func willBuildPackage() {
            print(Colors.cyan("\nBuilding package...\n"))
        }
        
        func willMoveExecutables() {
            print(Colors.cyan("\nMoving executables..."))
        }
    }
}
