import Foundation
import SwiftUI

struct ReinforcementHomeCard: View {
    @State private var insight = QuitInsightLibrary.random()
    @State private var showingDetail = false

    private let accent = Color(red: 0.07, green: 0.43, blue: 0.34)
    private let ink = Color(red: 0.08, green: 0.12, blue: 0.12)
    private let secondaryText = Color(red: 0.38, green: 0.43, blue: 0.42)

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("今日巩固", systemImage: "book.closed.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(accent)

                    Spacer()

                    Text(insight.category)
                        .font(.caption.weight(.medium))
                        .foregroundColor(accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(accent.opacity(0.09))
                        .clipShape(Capsule())
                }

                Text(insight.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(ink)
                    .multilineTextAlignment(.leading)

                Text(insight.preview)
                    .font(.subheadline)
                    .foregroundColor(secondaryText)
                    .lineSpacing(3)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                HStack {
                    Text("《这书能让你戒烟》观点整理")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(accent)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(accent)
                }
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.black.opacity(0.045), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            ReinforcementDetailView(insight: $insight)
        }
    }
}

private struct ReinforcementDetailView: View {
    @Binding var insight: QuitInsight
    @Environment(\.dismiss) private var dismiss

    private let accent = Color(red: 0.07, green: 0.43, blue: 0.34)
    private let pageBackground = Color(red: 0.955, green: 0.965, blue: 0.95)
    private let ink = Color(red: 0.08, green: 0.12, blue: 0.12)
    private let secondaryText = Color(red: 0.38, green: 0.43, blue: 0.42)

    var body: some View {
        NavigationView {
            ZStack {
                pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text(insight.category)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(accent)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(accent.opacity(0.1))
                                .clipShape(Capsule())

                            Spacer()

                            Text("共 \(QuitInsightLibrary.all.count) 条")
                                .font(.caption)
                                .foregroundColor(secondaryText)
                        }

                        Text(insight.title)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(ink)

                        Text(insight.body)
                            .font(.system(size: 17))
                            .foregroundColor(ink.opacity(0.86))
                            .lineSpacing(7)
                            .fixedSize(horizontal: false, vertical: true)

                        Divider()

                        Text("本页按亚伦·卡尔《这书能让你戒烟》的章节和核心论证重新整理，用于日常巩固；内容不是原书逐字摘录。")
                            .font(.caption)
                            .foregroundColor(secondaryText)
                            .lineSpacing(3)

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                insight = QuitInsightLibrary.random(excluding: insight.id)
                            }
                        } label: {
                            Label("随机换一条", systemImage: "shuffle")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(accent)
                                .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                        }
                    }
                    .padding(22)
                }
            }
            .navigationTitle("书中观点")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
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

    var preview: String {
        let limit = 72
        guard body.count > limit else { return body }
        return String(body.prefix(limit)) + "……"
    }
}
