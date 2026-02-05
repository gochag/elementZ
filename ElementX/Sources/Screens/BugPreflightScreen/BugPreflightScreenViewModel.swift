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
    private let clientProxy: ClientProxyProtocol
    private let actionsSubject: PassthroughSubject<BugPreflightScreenViewModelAction, Never> = .init()
    
    var actions: AnyPublisher<BugPreflightScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    init(with param: BugPreflightScreenCoordinatorParameters) {
        let bindings = BugPreflightScreenViewStateBindings()
        let state = BugPreflightScreenViewState(bindings: bindings)
        
        diagnosticsProviding = param.diagnosticsProviding
        textRedacting = param.textRedacting
        clientProxy = param.clientProxy
        
        super.init(initialViewState: state)
        setupBindings()
    }
    
    private func setupBindings() {
        diagnosticsData()
    }
    
    private func diagnosticsData() {
        Task {
            guard let result = try? await diagnosticsProviding.collectDiagnostics() else { return }
            state.bindings.deviceDiagnostics = result
            
            let user = clientProxy.userID
            let homeserver = clientProxy.homeserver
            let deviceID = clientProxy.deviceID
            
            let text = """
            [user] \(user)
            [homeserver] \(homeserver)
            [deviceID] \(deviceID)
            
            [Device] \(result.deviceModel)
            [OS Version]: \(result.osVersion)
            [Locale]: \(result.locale)
            [App Version]: \(result.appVersion)
            [Timestamp]: \(result.formatted())
            """
            state.bindings.diagnosticText = text
        }
    }
}
