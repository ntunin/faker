
//
//  Created by n.tyunin on 22.06.2023.
//

import ArgumentParser
import Foundation

public final class Fake: ParsableCommand {

    public static let configuration: CommandConfiguration = .init(commandName: "fake",
                                                                  abstract: "Falcificate some project by your custom configuration", 
                                                                  usage: """
                                                                         fake --yml <fake.yml> --proj <path> <subcommand>
                                                                         See 'fake --help' for more information.
                                                                         
                                                                         YML Format:
                                                                         replace:
                                                                           - files: <files mask or path>
                                                                             from: <original string>
                                                                             to: <target string>
                                                                         remove:
                                                                           - files: <files mask or path>
                                                                             string: <original string>
                                                                         xcode:
                                                                           - project: <xcproj file name>
                                                                             drop:
                                                                               targets:
                                                                                 except: <bool, true - except list, false - include only list>
                                                                                 list: <list of targets>
                                                                               capabilities:
                                                                                 except: <bool, true - except list, false - include only list>
                                                                                 list: <list of targets>
                                                                               build_phases: <list of build phases>
                                                                         """)

    public typealias Dependencies = HasFakeProjectConfigParser & HasFileService & HasXcodeService

    @Option(name: [.customLong("yml"), .customShort("y")],
            help: .init(stringLiteral: "Path to yml configuration file"),
            completion: .file(extensions: ["yml"]))
    var ymlPath: String
            
    @Option(name: [.customLong("proj"), .customShort("p")],
            help: .init(stringLiteral: "Path to project folder"),
            completion: .directory)
    var projPath: String

    private var dependencies: Dependencies {
        Services
    }

    // MARK: - Lifecycle

    public init() {
    }

    public func run() throws {
        let config = try dependencies.fakeProjectConfigParser.parse(yml: ymlPath)
        try dependencies.fileService.apply(replace: config.replace, remove: config.remove, folder: projPath)
        try dependencies.xcodeService.apply(list: config.xcode, folder: projPath)
    }
}
