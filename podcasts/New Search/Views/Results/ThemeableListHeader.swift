import SwiftUI

struct ThemeableListHeader: View {
    @EnvironmentObject var theme: Theme

    let title: String

    let actionTitle: String?

    let action: (() -> ())?

    init(title: String, actionTitle: String?, action: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        HStack {
            Text(title)
                .font(style: .title2, weight: .bold)
            Spacer()
            if let actionTitle {
                Button(actionTitle.uppercased()) {
                    action?()
                }
                .font(style: .footnote, weight: .bold)
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 12))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(AppTheme.color(for: .primaryUi02, theme: theme))
    }
}
