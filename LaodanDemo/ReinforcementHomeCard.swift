import Foundation
import SwiftUI

struct ReinforcementTabView: View {
    @State private var insight = QuitInsightLibrary.random()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                PageHeading(title: "今日巩固", subtitle: "留一点时间，读懂一个观点。")

                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text(insight.category)
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppTheme.lavenderInk)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppTheme.lavender)
                            .clipShape(Capsule())
                        Spacer()
                        Image(systemName: "book")
                            .font(.system(size: 19))
                            .foregroundColor(AppTheme.lavenderInk)
                    }

                    Text(insight.title)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(AppTheme.ink)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()

                    Text(insight.body)
                        .font(.body)
                        .foregroundColor(AppTheme.ink.opacity(0.88))
                        .lineSpacing(9)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("亚伦·卡尔戒烟理念 · 观点整理")
                        .font(.caption)
                        .foregroundColor(AppTheme.muted)
                        .padding(.top, 8)
                }
                .softPanel()

                Button {
                    insight = QuitInsightLibrary.random(excluding: insight.id)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("换一个观点")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppTheme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(AppTheme.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)

                Text("共 \(QuitInsightLibrary.all.count) 条观点，按《这书能让你戒烟》的核心论证重新整理，非原书逐字摘录。")
                    .font(.caption)
                    .foregroundColor(AppTheme.muted)
                    .lineSpacing(4)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: 580)
            .frame(maxWidth: .infinity)
            .padding(22)
        }
        .background(AppTheme.page.ignoresSafeArea())
    }
}

struct QuitInsight: Identifiable, Equatable {
    let id = UUID()
    let category: String
    let title: String
    let body: String

    init(_ category: String, _ title: String, _ body: String) {
        self.category = category
        self.title = title
        self.body = body
    }
}
