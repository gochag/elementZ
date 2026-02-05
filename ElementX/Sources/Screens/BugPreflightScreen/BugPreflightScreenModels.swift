//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Foundation

enum BugPreflightScreenViewModelAction { }

struct BugPreflightScreenViewState: BindableState {
    var bindings: BugPreflightScreenViewStateBindings
}

struct BugPreflightScreenViewStateBindings {
    var summary: String = ""
    var steps: String = ""
    var expectedResults: String = ""
    var actualResult: String = ""
    var diagnosticText: String = ""
    var deviceDiagnostics: DeviceDiagnostics?
}

enum BugPreflightScreenViewActions { }
