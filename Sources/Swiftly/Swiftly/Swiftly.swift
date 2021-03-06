//
//  Swiftly.swift
//
//
//  Created by Jochen Bernard on 29/03/2022.
//

import ArgumentParser
import Foundation

@main
struct Swiftly: ParsableCommand {
    static let configuration = CommandConfiguration(subcommands: [
        Install.self,
        Update.self,
        Remove.self,
        List.self
    ])
    
    static let directory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".swiftly")
    static let binDirectory = directory.appendingPathComponent("bin")
    
    static func useDirectory(_ url: URL) throws {
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: url.absoluteString, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                throw SwiftlyError.failedToCreateDirectory(url)
            }
        } else if !isDirectory.boolValue {
            throw SwiftlyError.failedToCreateDirectory(url)
        }
    }
}
