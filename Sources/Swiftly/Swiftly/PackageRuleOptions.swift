//
//  PackageRuleOptions.swift
//  
//
//  Created by Jochen Bernard on 31/03/2022.
//

import ArgumentParser

struct PackageRuleOptions: ParsableArguments {
    @Option(help: "The major version to use.")
    var major: String?
    
    @Option(help: "The minor version to use.")
    var minor: String?
    
    @Option(help: "The range of versions to use.")
    var range: String?
    
    @Option(help: "The version to use.")
    var version: String?
    
    @Option(help: "The branch to use.")
    var branch: String?
    
    @Option(help: "The commit to use.")
    var commit: String?
    
    var packageRule: PackageRule? {
        get throws {
            var packageRules: [PackageRule] = []
                        
            if let major = major {
                packageRules.append(.major(major))
            }
            
            if let minor = minor {
                packageRules.append(.minor(minor))
            }
            
            if let range = range {
                let versions = range.split(separator: "-")
                                
                guard versions.count == 2 && versions[0].count > 0 && versions[1].count > 0 else {
                    throw SwiftlyError.invalidRangeSpecified(range)
                }
                
                packageRules.append(.range(String(versions[0]), String(versions[1])))
            }
            
            if let version = version {
                packageRules.append(.version(version))
            }
            
            if let branch = branch {
                packageRules.append(.branch(branch))
            }
            
            if let commit = commit {
                packageRules.append(.commit(commit))
            }
            
            guard packageRules.count <= 1 else {
                throw SwiftlyError.multiplePackageRulesSpecified(packageRules)
            }
            
            return packageRules.count > 0 ? packageRules[0] : nil
        }
    }
}
