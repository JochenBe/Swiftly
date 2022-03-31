//
//  Swiftly+Install.swift
//  
//
//  Created by Jochen Bernard on 30/03/2022.
//

import ArgumentParser
import Foundation

extension Swiftly {
    struct Install: ParsableCommand, PackageInstallerDelegate {
        @Argument(help: "The URL of the package to install.")
        var url: String
        
        @OptionGroup var packageRuleOptions: PackageRuleOptions
        
        func run() throws {
            try Swiftly.useDirectory(Swiftly.binDirectory)
            
            guard try Packages.get(by: url) == nil else {
                throw SwiftlyError.packageAlreadyInstalled(url)
            }
            
            guard var url = URL(string: url) else {
                throw SwiftlyError.failedToConvertStringToURL(url)
            }
            
            if !(url.scheme?.starts(with: "http") ?? false) {
                let github = "https://github.com"
                guard let github = URL(string: github) else {
                    throw SwiftlyError.failedToConvertStringToURL(github)
                }
                
                url = github.appendingPathComponent(url.path)
            }
            
            let packageRule = try packageRuleOptions.packageRule
            
            let packageInstaller = PackageInstaller(
                url: url,
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
