//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
import Foundation

enum BugPreflightFlowCoordinatorAction: Equatable {
    /// The flow is complete.
    case complete
}

struct BugPreflightFlowCoordinatorParameters {
    enum PresentationMode {
        case sheet(NavigationStackCoordinator)
        case push(NavigationStackCoordinator)
    }

    let presentationMode: PresentationMode
    let clientProxy: ClientProxyProtocol
    let userIndicatorController: UserIndicatorControllerProtocol
}

class BugPreflightFlowCoordinator: FlowCoordinatorProtocol {
    private let parameters: BugPreflightFlowCoordinatorParameters
    private var cancellables = Set<AnyCancellable>()
    
    private let actionsSubject: PassthroughSubject<BugPreflightFlowCoordinatorAction, Never> = .init()
    var actionsPublisher: AnyPublisher<BugPreflightFlowCoordinatorAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    private var internalNavigationStackCoordinator: NavigationStackCoordinator?
    
    init(parameters: BugPreflightFlowCoordinatorParameters) {
        self.parameters = parameters
    }

    func start(animated: Bool) {
        presentBugReportScreen()
    }
    
    func handleAppRoute(_ appRoute: AppRoute, animated: Bool) { }
    
    func clearRoute(animated: Bool) { }
    
    private func presentBugReportScreen() {
        let textRedacting = PrivacyRedactor()
        let diagnosticsProviding = SystemDiagnosticsProvider()
        
        let params = BugPreflightScreenCoordinatorParameters(clientProxy: parameters.clientProxy,
                                                             diagnosticsProviding: diagnosticsProviding,
                                                             textRedacting: textRedacting,
                                                             userIndicatorController: parameters.userIndicatorController)
        
        let coordinator = BugPreflightScreenCoordinator(parameters: params)
        coordinator.actions.sink { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .cancel:
                dismiss()
            case .finish:
                //                showSuccess(label: L10n.actionDone)
                dismiss()
            }
        }
        .store(in: &cancellables)
        
        switch parameters.presentationMode {
        case .sheet(let navigationStackCoordinator):
            let internalNavigationStackCoordinator = NavigationStackCoordinator()
            internalNavigationStackCoordinator.setRootCoordinator(coordinator)
            navigationStackCoordinator.setSheetCoordinator(internalNavigationStackCoordinator) { [weak self] in
                self?.actionsSubject.send(.complete)
            }
            self.internalNavigationStackCoordinator = internalNavigationStackCoordinator
        case .push(let navigationStackCoordinator):
            internalNavigationStackCoordinator = navigationStackCoordinator
            navigationStackCoordinator.push(coordinator) { [weak self] in
                self?.actionsSubject.send(.complete)
            }
        }
        coordinator.start()
    }
    
    private func dismiss() {
        switch parameters.presentationMode {
        case .push(let navigationStackCoordinator):
            navigationStackCoordinator.pop()
        case .sheet(let navigationStackCoordinator):
            navigationStackCoordinator.setSheetCoordinator(nil)
        }
    }
}
