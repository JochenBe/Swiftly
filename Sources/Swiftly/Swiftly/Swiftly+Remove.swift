//
//  Swiftly+Remove.swift
//
//
//  Created by Jochen Bernard on 30/03/2022.
//

import ArgumentParser
import Foundation

extension Swiftly {
    struct Remove: ParsableCommand, PackageRemoverDelegate {
        @OptionGroup var options: Options
        
        func run() throws {
            guard let url = URL(string: options.url) else {
                throw SwiftlyError.failedToConvertStringToURL(options.url)
            }
            
            try Swiftly.useDirectory(Swiftly.binDirectory)
            
            let packageRemover = PackageRemover(url: url, delegate: self)
            try packageRemover.resume()
        }
        
        func willRemoveExecutables() {
            print(Colors.cyan("Removing executables..."))
        }
    }
}
