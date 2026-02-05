//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Foundation

struct DeviceDiagnostics {
    let appVersion: String
    let deviceModel: String
    let osVersion: String
    let locale: String
    let timestamp: Date
    let matrixSDKVersion: String?
    let homeserver: String?
    
    func formatted() -> String {
        var lines: [String] = [
            "App Version: \(appVersion)",
            "Device: \(deviceModel)",
            "OS: \(osVersion)",
            "Locale: \(locale)",
            "Generated: \(formattedTimestamp)"
        ]
        
        if let sdkVersion = matrixSDKVersion {
            lines.append("Matrix SDK: \(sdkVersion)")
        }
        
        if let server = homeserver {
            lines.append("Homeserver: \(server)")
        }
        
        return lines.map { "- \($0)" }.joined(separator: "\n")
    }
    
    private var formattedTimestamp: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withSpaceBetweenDateAndTime]
        return formatter.string(from: timestamp)
    }
}
