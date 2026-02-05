//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Foundation
import UIKit

protocol DiagnosticsProviding {
    func collectDiagnostics() async throws -> DeviceDiagnostics
}

final class SystemDiagnosticsProvider: DiagnosticsProviding {
    func collectDiagnostics() async throws -> DeviceDiagnostics {
        DeviceDiagnostics(appVersion: appVersion,
                          deviceModel: deviceModel,
                          osVersion: osVersion,
                          locale: locale,
                          timestamp: Date(),
                          matrixSDKVersion: nil,
                          homeserver: nil)
    }
    
    // MARK: Private function
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) (\(build))"
    }
    
    private var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        return "\(UIDevice.current.model) (\(identifier))"
    }
    
    private var osVersion: String {
        "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
    
    private var locale: String {
        Locale.current.identifier
    }
}
