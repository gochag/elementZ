//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Foundation

protocol TextRedacting {
    func redact(_ text: String) -> String
}

final class PrivacyRedactor: TextRedacting {
    // MARK: - Placeholders
    
    private enum Placeholder {
        static let email = "[REDACTED_EMAIL]"
        static let url = "[REDACTED_URL]"
        static let matrixID = "[REDACTED_MATRIX_ID]"
    }
    
    // MARK: - Patterns
    
    private let matrixIDPattern = #"@[a-zA-Z0-9._=-]+:[a-zA-Z0-9.-]+"#
    private let emailPattern = #"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"#
    private let urlPattern = #"https?://[^\s\]\)]+"#
    
    // MARK: - TextRedacting
    
    func redact(_ text: String) -> String {
        var result = text
        result = redact(result, pattern: matrixIDPattern, replacement: Placeholder.matrixID)
        result = redact(result, pattern: emailPattern, replacement: Placeholder.email)
        result = redact(result, pattern: urlPattern, replacement: Placeholder.url)
        
        return result
    }
    
    // MARK: - Private
    
    private func redact(_ text: String, pattern: String, replacement: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return text
        }
        
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text,
                                              options: [],
                                              range: range,
                                              withTemplate: replacement)
    }
}
