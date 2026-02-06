//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
@testable import ElementX
import Foundation
import XCTest

@MainActor
final class DeviceDiagnosticsTests: XCTestCase {
    func testFormattedOutputIsDeterministic() {
        let fixedDate = Date(timeIntervalSince1970: 1704067278)
        let diagnostics = DeviceDiagnostics(appVersion: "1.0.0 (123)",
                                            deviceModel: "iPhone (iPhone15,2)",
                                            osVersion: "iOS 17.2",
                                            locale: "az_AZ",
                                            timestamp: fixedDate,
                                            matrixSDKVersion: nil,
                                            homeserver: nil)
        let result1 = diagnostics.formatted()
        let result2 = diagnostics.formatted()
        
        XCTAssertEqual(result1, result2, "Same input should produce identical output")
    }
    
    func testFormattedContainsAllRequiredFields() {
        let diagnostics = DeviceDiagnostics(appVersion: "2.5.0 (456)",
                                            deviceModel: "iPad Pro",
                                            osVersion: "iPadOS 17.0",
                                            locale: "us_US",
                                            timestamp: Date(),
                                            matrixSDKVersion: nil,
                                            homeserver: nil)
        
        let result = diagnostics.formatted()
        
        XCTAssertTrue(result.contains("App Version: 2.5.0 (456)"))
        XCTAssertTrue(result.contains("Device: iPad Pro"))
        XCTAssertTrue(result.contains("OS: iPadOS 17.0"))
        XCTAssertTrue(result.contains("Locale: us_US"))
        XCTAssertTrue(result.contains("Generated:"))
    }
    
    func testFormattedIncludesOptionalSDKVersion() {
        let diagnostics = DeviceDiagnostics(appVersion: "1.0.0",
                                            deviceModel: "iPhone",
                                            osVersion: "iOS 17.0",
                                            locale: "az_AZ",
                                            timestamp: Date(),
                                            matrixSDKVersion: "0.1.2",
                                            homeserver: nil)
        
        let result = diagnostics.formatted()
        
        XCTAssertTrue(result.contains("Matrix SDK: 0.1.2"))
    }
    
    func testFormattedIncludesOptionalHomeserver() {
        let diagnostics = DeviceDiagnostics(appVersion: "1.0.0",
                                            deviceModel: "iPhone",
                                            osVersion: "iOS 17.0",
                                            locale: "az_AZ",
                                            timestamp: Date(),
                                            matrixSDKVersion: nil,
                                            homeserver: "matrix.org")
        let result = diagnostics.formatted()
        
        XCTAssertTrue(result.contains("Homeserver: matrix.org"))
    }
    
    func testFormattedExcludesNilOptionalFields() {
        let diagnostics = DeviceDiagnostics(appVersion: "1.0.0",
                                            deviceModel: "iPhone",
                                            osVersion: "iOS 17.0",
                                            locale: "az_AZ",
                                            timestamp: Date(),
                                            matrixSDKVersion: nil,
                                            homeserver: nil)
        
        let result = diagnostics.formatted()
        
        XCTAssertFalse(result.contains("Matrix SDK:"))
        XCTAssertFalse(result.contains("Homeserver:"))
    }
}
