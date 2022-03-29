//
//  swiftly.swift
//
//
//  Created by Jochen Bernard on 29/03/2022.
//

import ArgumentParser
import Foundation

@main
struct swiftly: ParsableCommand {
    @Argument(help: "The URL of the package.")
    var url: String

    func run() throws {
        guard let packageURL = URL(string: url) else {
            throw SwiftlyError.failedToConvertArgumentToURL
        }
        
        guard let localBinURL = URL(string: "/usr/local/bin") else {
            throw SwiftlyError.failedToInitializeBinURL
        }
        
        let swiftlyDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".swiftly")
        
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: swiftlyDirectory.absoluteString, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(at: swiftlyDirectory, withIntermediateDirectories: true)
            } catch {
                throw SwiftlyError.failedToCreateSwiftlyDirectory
            }
        } else if !isDirectory.boolValue {
            throw SwiftlyError.failedToCreateSwiftlyDirectory
        }
        
        let packagePath = swiftlyDirectory.appendingPathComponent(packageURL.lastPathComponent).path
        
        guard Git.clone(from: packageURL, to: packagePath) == 0 else {
            throw SwiftlyError.failedToCloneRepository
        }
        
        defer {
            try? FileManager.default.removeItem(atPath: packagePath)
        }
        
        guard Swift.build(path: packagePath) == 0 else {
            throw SwiftlyError.failedToBuildPackage
        }
        
        guard let binURL = URL(string: Swift.getBinPath(path: packagePath)) else {
            throw SwiftlyError.failedToConvertBinPathToURL
        }
        
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: binURL.path) else {
            throw SwiftlyError.failedToGetContentsOfBinPath
        }
        
        let executables = contents.filter { content in
            !content.contains(".")
            &&
            FileManager.default.fileExists(atPath: binURL.appendingPathComponent(content).path, isDirectory: &isDirectory)
            &&
            !isDirectory.boolValue
        }
        
        executables.forEach { executable in
            let localBinPath = localBinURL.appendingPathComponent(executable).path
            guard !FileManager.default.fileExists(atPath: localBinPath) else { return }
            
            do {
                try FileManager.default.moveItem(atPath: binURL.appendingPathComponent(executable).path, toPath: localBinPath)
            } catch {
                print(error)
            }
        }
    }
}
