//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

struct BugPreflightScreen: View {
    /* Не стал добавлять в ресурсы. В идеале нужно туда добавить */
    enum Texts {
        static let summary = "Summary"
        static let stepsToReproduce = "Steps to Reproduce"
        static let expectedResult = "Expected Result"
        static let actualResult = "Actual Result"
        static let diagnostics = "Diagnostics"
        static let share = "Share"
        static let copy = "Copy"
    }
    
    @Bindable var context: BugPreflightScreenViewModel.Context
    
    var body: some View {
        Form {
            summarySection
            stepsToReproduceSection
            expectedSection
            actualResultSection
            diagnosticLogsSection
            buttonSection
        }
        .sheet(isPresented: $context.showShareSheet) { shareSheet }
        .scrollDismissesKeyboard(.immediately)
        .compoundList()
        .navigationTitle(L10n.commonReportAProblem)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
    
    private var summarySection: some View {
        Section {
            ListRow(label: .plain(title: L10n.screenBugReportEditorPlaceholder),
                    kind: .textField(text: $context.summary, axis: .horizontal))
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text(Texts.summary)
                .compoundListSectionHeader()
        } footer: {
            Text(L10n.screenBugReportEditorDescription)
                .compoundListSectionFooter()
        }
    }
    
    private var stepsToReproduceSection: some View {
        Section {
            ListRow(label: .plain(title: L10n.screenBugReportEditorPlaceholder),
                    kind: .textField(text: $context.steps, axis: .vertical))
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text(Texts.stepsToReproduce)
                .compoundListSectionHeader()
        }
    }
    
    private var expectedSection: some View {
        Section {
            ListRow(label: .plain(title: L10n.screenBugReportEditorPlaceholder),
                    kind: .textField(text: $context.expectedResults, axis: .horizontal))
                .lineLimit(4, reservesSpace: true)
                .accessibilityIdentifier(A11yIdentifiers.bugReportScreen.report)
        } header: {
            Text(Texts.expectedResult)
                .compoundListSectionHeader()
        }
    }
    
    private var actualResultSection: some View {
        Section {
            ListRow(label: .plain(title: L10n.screenBugReportEditorPlaceholder),
                    kind: .textField(text: $context.actualResult, axis: .horizontal))
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text(Texts.actualResult)
                .compoundListSectionHeader()
        }
    }
    
    private var diagnosticLogsSection: some View {
        Section {
            ListRow(label: .plain(title: context.diagnosticText),
                    kind: .label)
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text(Texts.diagnostics)
                .compoundListSectionHeader()
        }
    }
    
    private var buttonSection: some View {
        Section {
            ListRow(label: .action(title: Texts.share, systemIcon: .squareAndArrowUp),
                    kind: .button {
                        context.send(viewAction: .share)
                    })
                
            ListRow(label: .action(title: Texts.copy, systemIcon: .documentOnDocument),
                    kind: .button {
                        context.send(viewAction: .copyClipboard)
                    })
        }
    }
    
    @ViewBuilder
    private var shareSheet: some View {
        let report = context.reportForSharing
        AppActivityView(activityItems: [report])
            .edgesIgnoringSafeArea(.bottom)
            .presentationDetents([.medium, .large])
            .presentationCompactAdaptation(shareSheetCompactPresentation)
            .presentationDragIndicator(.hidden)
    }
    
    private var shareSheetCompactPresentation: PresentationAdaptation {
        if #available(iOS 26.0, *) {
            .none // ShareLinks use a popover presentation on iOS 26, let it match that.
        } else {
            .sheet
        }
    }
}
