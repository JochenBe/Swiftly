//
//  Packages.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation

struct Packages {
    private static let url = Swiftly.directory.appendingPathComponent("packages.json")
    
    private static func get() throws -> [Package] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw SwiftlyError.failedToReadPackages(url)
        }
        
        let decoder = JSONDecoder()
        guard let packages = try? decoder.decode([Package].self, from: data) else {
            throw SwiftlyError.failedToDecodePackages(data)
        }
        
        return packages
    }
    
    private static func set(_ packages: [Package]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(packages) else {
            throw SwiftlyError.failedToEncodePackages(packages)
        }
        
        do {
            try data.write(to: url)
        } catch {
            throw SwiftlyError.failedToWritePackages(url)
        }
    }
    
    static func get(by string: String) throws -> Package? {
        let packages = try get()
        
        for package in packages {
            if (
                package.url.absoluteString == string
                ||
                package.url.path.trimmingCharacters(in: .init(charactersIn: "/")) == string
                ||
                package.executables.contains(string)
            ) {
                return package
            }
        }
        
        return nil
    }
    
    static func getConflictingPackages(for package: Package) throws -> [Package] {
        var packages = try get()
        
        let executables = Set(package.executables)
        
        packages = packages.filter { p in
            !Set(p.executables).isDisjoint(with: executables)
            &&
            p.url != package.url
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
