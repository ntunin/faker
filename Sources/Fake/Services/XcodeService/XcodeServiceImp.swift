//
//  Created by n.tyunin on 22.06.2023.
//

import PathKit
import XcodeProj
import Foundation

final class XcodeServiceImp: XcodeService {
    func apply(list: [FakeXcode]?, folder: String) throws {
        guard let list else {
            return
        }
        try list.forEach { xcode in
            try apply(xcode, folder: folder)
        }
    }
    
    private func apply(_ xcode: FakeXcode, folder: String) throws {
        guard let path = Path(folder).glob("*/\(xcode.project).xcodeproj").first, 
              let project = try? XcodeProj(path: path) else {
            throw XcodeError.none(xcode.project)
        }
        try drop(targets: xcode.drop.targets, in: project)
        try drop(capabilities: xcode.drop.capabilities, in: path.parent(), project: project)
        try drop(buildPhases: xcode.drop.buildPhases, in: project)
        do {
            try project.write(path: path, override: true)
        } catch {
            throw XcodeError.write(path.string)
        }
    }
    
    private func drop(targets: FakeXcodeDropList?, in project: XcodeProj) throws {
        guard let list = targets else {
            return
        }
        func filter() -> [PBXTarget] {
            var targets = [PBXTarget]()
            if list.except {
                var allTargets = [PBXTarget]()
                allTargets.append(contentsOf: project.pbxproj.nativeTargets)
                allTargets.append(contentsOf: project.pbxproj.legacyTargets)
                allTargets.append(contentsOf: project.pbxproj.aggregateTargets)
                guard let list = list.list else {
                    return allTargets
                }
                targets = allTargets.filter { target in
                    list.contains(target.name) == false
                }
            } else {
                list.list?.forEach { name in
                    targets.append(contentsOf: project.pbxproj.targets(named: name))
                }
            }
            return targets
        }
        let targets = filter()
        project.pbxproj.buildPhases.forEach { phase in
            guard phase.name() == "Embed App Extensions" else {
                return
            }
            let files = phase.files?.filter { file in
                !targets.contains { file.file?.path == $0.product?.path }
            }
            phase.files = files
        }
        targets.forEach { target in
            project.pbxproj.delete(object: target)
        }
    }
    
    private func drop(capabilities: FakeXcodeDropList?, in path: Path, project: XcodeProj) throws {
        guard let list = capabilities else {
            return
        }
        let except = list.except
        let capabilities = list.list ?? []
        
        func removeEntitlements(_ dictionary: NSDictionary) -> NSDictionary? {
            guard var dict = dictionary as? [String: Any] else {
                return nil
            }
            var handled = false
            dict.keys.forEach { key in
                if (!except && capabilities.contains(key)) || (except && !capabilities.contains(key)) {
                    dict.removeValue(forKey: key)
                    handled = true
                }
            }
            
            return handled ? dict as NSDictionary : nil
        }
        
        let infoKeys = ["NSExceptionDomains", "UIBackgroundModes"].filter { key in
            capabilities.contains(key) != except
        }
        func removeInfo(_ dictionary: NSDictionary) -> NSDictionary? {
            guard var dict = dictionary as? [String: Any] else {
                return nil
            }
            var handled = false
            dict.keys.forEach { key in
                if infoKeys.contains(key) {
                    dict.removeValue(forKey: key)
                    handled = true
                } else if let subdict = dict[key] as? NSDictionary, 
                          let modified = removeInfo(subdict) {
                    dict[key] = modified
                    handled = true
                }
            }
            return handled ? dict as NSDictionary : nil
        }
        
        func update(paths: [Path], handler: (NSDictionary) -> NSDictionary?) {
            paths.forEach { path in
                guard let dict = NSDictionary(contentsOfFile: path.string),
                      let modified = handler(dict) else {
                    return
                }
                modified.write(toFile: path.string, atomically: true)
            }
        }
        
        update(paths: paths(path, pattern: "*/**/*.entitlements"), handler: removeEntitlements)
        update(paths: paths(path, pattern: "*/**/*.plist"), handler: removeInfo)
        
        let containsInAppPurhcase = capabilities.contains("InAppPurchse")
        if (except && !containsInAppPurhcase || (!except && containsInAppPurhcase)) {
            let refs = project.pbxproj.fileReferences.filter { dependency in
                dependency.name == "StoreKit.framework"
            }
            refs.forEach { ref in
                project.pbxproj.delete(object: ref)
            }
        }
    }
    
    private func paths(_ path: Path, pattern: String) -> [Path] {
        (try? path.recursiveChildren().filter { $0.match(pattern) }) ?? []
    }
    
    private func drop(buildPhases: [String]?, in project: XcodeProj) throws {
        guard let list = buildPhases else {
            return
        }
        func filter() -> [PBXBuildPhase] {
            project.pbxproj.buildPhases.filter { phase in
                guard let name = phase.name() else {
                    return false
                }
                return list.contains(name)
            }
        }
        filter().forEach { phase in
            project.pbxproj.delete(object: phase)
        }
    }
}
