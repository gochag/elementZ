//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine

typealias BugPreflightScreenViewModelType = StateStoreViewModelV2<BugPreflightScreenViewState, BugPreflightScreenViewActions>

final class BugPreflightScreenViewModel: BugPreflightScreenViewModelType, BugPreflightScreenViewModelProtocol {
    private let diagnosticsProviding: DiagnosticsProviding
    private let textRedacting: TextRedacting
    private let actionsSubject: PassthroughSubject<BugPreflightScreenViewModelAction, Never> = .init()
    
    var actions: AnyPublisher<BugPreflightScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    init(with param: BugPreflightScreenCoordinatorParameters) {
        let bindings = BugPreflightScreenViewStateBindings(reportText: "")
        let state = BugPreflightScreenViewState(bindings: bindings)
        diagnosticsProviding = param.diagnosticsProviding
        textRedacting = param.textRedacting
        
        super.init(initialViewState: state)
    }
}
