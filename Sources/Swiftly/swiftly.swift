//
//  swiftly.swift
//
//
//  Created by Jochen Bernard on 29/03/2022.
//

import ArgumentParser
import Foundation

@main
struct swiftly: ParsableCommand, PackageInstallerDelegate {
    @Argument(help: "The URL of the package.")
    var url: String
    
    static let directory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".swiftly")
    static let binDirectory = directory.appendingPathComponent("bin")

    static func useDirectory(_ url: URL) throws {
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: url.absoluteString, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                throw SwiftlyError.failedToCreateDirectory
            }
        } else if !isDirectory.boolValue {
            throw SwiftlyError.failedToCreateDirectory
        }
    }
    
    func run() throws {
        guard let url = URL(string: url) else {
            throw SwiftlyError.failedToConvertStringToURL
        }
                
        let packageInstaller = PackageInstaller(url: url, delegate: self)
        try packageInstaller.resume()
    }
    
    func willCloneRepository() {
        print("Cloning repository...\n")
    }
    
    func willBuildPackage() {
        print("\nBuilding package...\n")
    }
    
    func willMoveExecutables() {
        print("\nMoving executables...")
    }
}
