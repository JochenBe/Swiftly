//
//  Packages.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

final class Packages {
    private static let url = swiftly.directory.appendingPathComponent("packages.json")
    
    private init() {}
    
    static func get() throws -> [Package] {
        guard let data = try? Data(contentsOf: url) else {
            throw SwiftlyError.failedToReadPackages
        }
        
        let decoder = JSONDecoder()
        guard let packages = try? decoder.decode([Package].self, from: data) else {
            throw SwiftlyError.failedToDecodePackages
        }
        
        return packages
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
    
    static func set(_ packages: [Package]) throws {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(packages) else {
            throw SwiftlyError.failedToEncodePackages
        }
        
        do {
            try data.write(to: url)
        } catch {
            throw SwiftlyError.failedToWritePackages
        }
    }
    
    static func add(_ package: Package) throws {
        var packages = try get()
        
        packages = packages.filter { p in
            p.url != package.url
        }
        
        packages.append(package)
        
        try set(packages)
    }
}
