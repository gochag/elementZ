//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
import Foundation

enum BugPreflightFlowCoordinatorParameters {
    enum PresentationMode {
        case sheet(NavigationStackCoordinator)
        case push(NavigationStackCoordinator)
    }
}

class BugPreflightFlowCoordinator: FlowCoordinatorProtocol {
    private let parameters: BugPreflightFlowCoordinatorParameters
    private var cancellables = Set<AnyCancellable>()
    
    private let actionsSubject: PassthroughSubject<BugPreflightFlowCoordinatorParameters, Never> = .init()
    var actionsPublisher: AnyPublisher<BugPreflightFlowCoordinatorParameters, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    init(parameters: BugPreflightFlowCoordinatorParameters) {
        self.parameters = parameters
    }

    func start(animated: Bool) {
        presentBugReportScreen()
    }
    
    func handleAppRoute(_ appRoute: AppRoute, animated: Bool) { }
    
    func clearRoute(animated: Bool) { }
    
    private func presentBugReportScreen() {
        let params = BugPreflightScreenCoordinator(parameters: .init(hideProfiles: true))
        let coordinator = BugPreflightScreenCoordinator(parameters: .init(hideProfiles: true))
        coordinator.actions.sink { [weak self] _ in
            guard let self else { return }
            
//            switch action {
//            case .cancel:
//                dismiss()
//            case .viewLogs:
            ////                presentLogViewerScreen()
//                dismiss()
//            case .finish:
            ////                showSuccess(label: L10n.actionDone)
//                dismiss()
//            }
        }
        .store(in: &cancellables)
        
//        switch parameters.presentationMode {
//        case .sheet(let navigationStackCoordinator):
//            let internalNavigationStackCoordinator = NavigationStackCoordinator()
//            internalNavigationStackCoordinator.setRootCoordinator(coordinator)
//            navigationStackCoordinator.setSheetCoordinator(internalNavigationStackCoordinator) { [weak self] in
//                self?.actionsSubject.send(.complete)
//            }
//            self.internalNavigationStackCoordinator = internalNavigationStackCoordinator
//        case .push(let navigationStackCoordinator):
//            internalNavigationStackCoordinator = navigationStackCoordinator
//            navigationStackCoordinator.push(coordinator) { [weak self] in
//                self?.actionsSubject.send(.complete)
//            }
//        }
        coordinator.start()
    }
}
