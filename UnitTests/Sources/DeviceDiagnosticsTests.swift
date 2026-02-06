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
final class PrivacyRedactorTests: XCTestCase {
    var redactor: PrivacyRedactor!
    
    override func setUp() {
        redactor = PrivacyRedactor()
    }
    
    // MARK: - Email Tests
    
    func testRedactsSimpleEmail() {
        let input = "Contact: john@example.com"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("john@example.com"))
        XCTAssertTrue(result.contains("[REDACTED_EMAIL]"))
    }
    
    func testRedactsComplexEmail() {
        let input = "Email: user.name+tag@sub.domain.co.uk for support"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("user.name+tag@sub.domain.co.uk"))
        XCTAssertTrue(result.contains("[REDACTED_EMAIL]"))
    }
    
    // MARK: - Matrix ID Tests
    
    func testRedactsMatrixID() {
        let input = "User @alice:matrix.org reported an issue"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("@alice:matrix.org"))
        XCTAssertTrue(result.contains("[REDACTED_MATRIX_ID]"))
    }
    
    func testRedactsComplexMatrixID() {
        let input = "Logged in as @user_name-123:example.server.com"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("@user_name-123:example.server.com"))
        XCTAssertTrue(result.contains("[REDACTED_MATRIX_ID]"))
    }
    
    // MARK: - URL Tests
    
    func testRedactsHTTPSUrl() {
        let input = "Server: https://matrix.example.com/api/v1"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("https://matrix.example.com"))
        XCTAssertTrue(result.contains("[REDACTED_URL]"))
    }
    
    func testRedactsHTTPUrl() {
        let input = "Visit http://example.com for more info"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("http://example.com"))
        XCTAssertTrue(result.contains("[REDACTED_URL]"))
    }
    
    func testDoesNotRedactDomainWithoutProtocol() {
        let input = "Visit example.com for more info"
        let result = redactor.redact(input)
        
        XCTAssertEqual(input, result)
    }
    
    // MARK: - Combined Tests
    
    func testRedactsMultipleTypes() {
        let input = "User @alice:matrix.org logged in from https://element.io. Contact help@element.io"
        let result = redactor.redact(input)
        
        XCTAssertFalse(result.contains("@alice:matrix.org"))
        XCTAssertFalse(result.contains("https://element.io"))
        XCTAssertFalse(result.contains("help@element.io"))
        XCTAssertTrue(result.contains("[REDACTED_MATRIX_ID]"))
        XCTAssertTrue(result.contains("[REDACTED_URL]"))
        XCTAssertTrue(result.contains("[REDACTED_EMAIL]"))
    }
    
    // MARK: - Preservation Tests
    
    func testPreservesNonSensitiveText() {
        let input = "The app crashes on launch when clicking the button"
        let result = redactor.redact(input)
        
        XCTAssertEqual(input, result)
    }
    
    func testPreservesPartialText() {
        let input = "Error code: 12345, Status: failed"
        let result = redactor.redact(input)
        
        XCTAssertEqual(input, result)
    }
}
