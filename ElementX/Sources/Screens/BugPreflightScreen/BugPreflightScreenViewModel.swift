//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
import SwiftUI

typealias BugPreflightScreenViewModelType = StateStoreViewModelV2<BugPreflightScreenViewState, BugPreflightScreenViewActions>

final class BugPreflightScreenViewModel: BugPreflightScreenViewModelType, BugPreflightScreenViewModelProtocol {
    private let diagnosticsProviding: DiagnosticsProviding
    private let textRedacting: TextRedacting
    private let clientProxy: ClientProxyProtocol
    private let userIndicatorController: UserIndicatorControllerProtocol
    private let actionsSubject: PassthroughSubject<BugPreflightScreenViewModelAction, Never> = .init()
    
    private var diagnosticsTask: Task<Void, Never>?
    var actions: AnyPublisher<BugPreflightScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    init(with param: BugPreflightScreenCoordinatorParameters) {
        let bindings = BugPreflightScreenViewStateBindings()
        let state = BugPreflightScreenViewState(bindings: bindings)
        
        diagnosticsProviding = param.diagnosticsProviding
        textRedacting = param.textRedacting
        clientProxy = param.clientProxy
        userIndicatorController = param.userIndicatorController
        
        super.init(initialViewState: state)
        setupBindings()
    }
    
    deinit {
        diagnosticsTask?.cancel()
    }
    
    // MARK: Override function
    
    override func process(viewAction: BugPreflightScreenViewActions) {
        let report = formatReport()
        state.bindings.reportForSharing = textRedacting.redact(report)
        
        switch viewAction {
        case .copyClipboard:
            UIPasteboard.general.string = state.bindings.reportForSharing
            userIndicatorController.submitIndicator(UserIndicator(title: "Copied", iconName: "checkmark"))
        case .share:
            state.bindings.showShareSheet = true
        }
    }
    
    // MARK: Private function

    private func setupBindings() {
        diagnosticsData()
    }
    
    private func diagnosticsData() {
        diagnosticsTask = Task {
            let result = await diagnosticsProviding.collectDiagnostics()
            let user = clientProxy.userID
            let homeserver = clientProxy.homeserver
            let deviceID = clientProxy.deviceID ?? "no data"
            
            guard !Task.isCancelled else { return }
            state.bindings.diagnosticText = """
            [user] \(user)
            [homeserver] \(homeserver)
            [deviceID] \(deviceID)
            
            [Device] \(result.deviceModel)
            [OS Version]: \(result.osVersion)
            [Locale]: \(result.locale)
            [App Version]: \(result.appVersion)
            [Timestamp]: \(result.formatted())
            """
        }
    }
    
    private func formatReport() -> String {
        """
        ## Bug Report\n
        **Summary:** \(state.bindings.summary)\n
        **Steps:** \(state.bindings.steps)\n
        **Expected:** \(state.bindings.expectedResults)\n
        **Actual:** \(state.bindings.actualResult)\n
        ---
        **Diagnostics:**\n
        \(state.bindings.diagnosticText)
        """
    }
}
