//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

struct BugPreflightScreen: View {
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
        .scrollDismissesKeyboard(.immediately)
        .compoundList()
        .navigationTitle(L10n.commonReportAProblem)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
        .interactiveDismissDisabled()
    }
    
    private var summarySection: some View {
        Section {
            ListRow(label: .plain(title: L10n.screenBugReportEditorPlaceholder),
                    kind: .textField(text: $context.summary, axis: .horizontal))
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text("Summary")
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
            Text("Steps to Reproduce")
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
            Text("Expected Result")
                .compoundListSectionHeader()
        }
    }
    
    private var actualResultSection: some View {
        Section {
            ListRow(label: .plain(title: L10n.screenBugReportEditorPlaceholder),
                    kind: .textField(text: $context.actualResult, axis: .horizontal))
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text("Actual Result")
                .compoundListSectionHeader()
        }
    }
    
    private var diagnosticLogsSection: some View {
        Section {
            ListRow(label: .plain(title: context.diagnosticText),
                    kind: .label)
                .lineLimit(4, reservesSpace: true)
        } header: {
            Text("Diagnostics")
                .compoundListSectionHeader()
        }
    }
    
    private var buttonSection: some View {
        Section {
            ListRow(label: .action(title: "Share", systemIcon: .squareAndArrowUp),
                    kind: .button(action: {
                        MXLog.debug("Share")
                    }))
            
            ListRow(label: .action(title: "Copy", systemIcon: .documentOnDocument),
                    kind: .button(action: {
                        MXLog.debug("Copy")
                    }))
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button(L10n.actionSend) {
//                context.send(viewAction: .submit)
            }
            .disabled(context.summary.count < 5)
        }
    }
}
