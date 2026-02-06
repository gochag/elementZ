//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
import SwiftUI

enum BugPreflightScreenCoordinatorAction {
    case cancel
    case finish
}

struct BugPreflightScreenCoordinatorParameters {
    let clientProxy: ClientProxyProtocol
    let diagnosticsProviding: DiagnosticsProviding
    let textRedacting: TextRedacting
    let userIndicatorController: UserIndicatorControllerProtocol
}

final class BugPreflightScreenCoordinator: CoordinatorProtocol {
    private let parameters: BugPreflightScreenCoordinatorParameters
    private var viewModel: BugPreflightScreenViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let actionsSubject: PassthroughSubject<BugPreflightScreenCoordinatorAction, Never> = .init()
    var actions: AnyPublisher<BugPreflightScreenCoordinatorAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }
    
    init(parameters: BugPreflightScreenCoordinatorParameters) {
        self.parameters = parameters
        viewModel = BugPreflightScreenViewModel(with: parameters)
    }
    
    // MARK: - Public
    
    func start() {
        viewModel
            .actions
            .sink { [weak self] action in
                MXLog.info("BugReportViewModel did complete with result: \(action).")
            }
            .store(in: &cancellables)
    }
    
    func toPresentable() -> AnyView {
        AnyView(BugPreflightScreen(context: viewModel.context))
    }
}
