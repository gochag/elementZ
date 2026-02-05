//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine

typealias BugPreflightScreenViewModelType = StateStoreViewModelV2<BugPreflightScreenViewState, BugPreflightScreenViewActions>

final class BugPreflightScreenViewModel: BugPreflightScreenViewModelType, BugPreflightScreenViewModelProtocol {
    private let actionsSubject: PassthroughSubject<BugPreflightScreenViewModelAction, Never> = .init()
    
    var actions: AnyPublisher<BugPreflightScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    init() {
        let bindings = BugPreflightScreenViewStateBindings(reportText: "")
        let state = BugPreflightScreenViewState(bindings: bindings)
        super.init(initialViewState: state)
    }
}
