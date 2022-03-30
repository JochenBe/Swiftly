//
//  Packages.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

final class Packages {
    private static let url = Swiftly.directory.appendingPathComponent("packages.json")
    
    private init() {}
    
    private static func get() throws -> [Package] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw SwiftlyError.failedToReadPackages
        }
        
        let decoder = JSONDecoder()
        guard let packages = try? decoder.decode([Package].self, from: data) else {
            throw SwiftlyError.failedToDecodePackages
        }
        
        return packages
    }
    
    private static func set(_ packages: [Package]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(packages) else {
            throw SwiftlyError.failedToEncodePackages
        }
        
        do {
            try data.write(to: url)
        } catch {
            throw SwiftlyError.failedToWritePackages
        }
    }
    
    static func get(by url: URL) throws -> Package? {
        let packages = try get()
        
        for package in packages {
            if package.url == url {
                return package
            }
        }
        
        return nil
    }
    
    static func get(by executables: Set<String>) throws -> [Package] {
        var packages = try get()
        
        packages = packages.filter { p in
            !Set(p.executables).isDisjoint(with: executables)
        }
        
        return packages
    }
    
    static func add(_ package: Package) throws {
        var packages = try get()
        
        packages = packages.filter { p in
            p.url != package.url
        }
        
        packages.append(package)
        
        try set(packages)
    }
    
    static func remove(_ package: Package) throws {
        var packages = try get()
        
        packages = packages.filter { p in
            p.url != package.url
        }
        
        try set(packages)
    }
}
