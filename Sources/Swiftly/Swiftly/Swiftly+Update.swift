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
        @Argument(help: "The package to update.")
        var package: String
        
        @OptionGroup var packageRuleOptions: PackageRuleOptions
        
        func run() throws {
            try Swiftly.useDirectory(Swiftly.binDirectory)
            
            guard let package = try Packages.get(by: package) else {
                throw SwiftlyError.packageNotFound(package)
            }
            
            let packageRule = try packageRuleOptions.packageRule
            
            let packageInstaller = PackageInstaller(
                package: package,
                rule: packageRule,
                delegate: self
            )
            
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
