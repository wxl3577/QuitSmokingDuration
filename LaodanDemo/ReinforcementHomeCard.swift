import Foundation
import SwiftUI

struct ReinforcementTabView: View {
    @State private var insight = QuitInsightLibrary.random()

    var body: some View {
        ZStack {
            AppTheme.pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    insightCard
                    shuffleButton

                    Text("内容按《这书能让你戒烟》的章节与核心论证重新整理，不是原书逐字摘录。")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                        .lineSpacing(3)
                        .padding(.horizontal, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 34)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 8) {
                Rectangle()
                    .fill(AppTheme.teal)
                    .frame(width: 22, height: 5)

                Text("保持清醒")
                    .font(.caption.weight(.black))
                    .tracking(2.5)
                    .foregroundColor(AppTheme.teal)
            }

            Text("今日巩固")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(AppTheme.ink)

            Text("不是忍耐，是重新看清吸烟。")
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
        }
    }

    private var insightCard: some View {
        ZStack(alignment: .topTrailing) {
            AppTheme.navy

            Circle()
                .fill(AppTheme.coral)
                .frame(width: 96, height: 96)
                .offset(x: 38, y: -38)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(insight.category)
                        .font(.caption.weight(.black))
                        .foregroundColor(AppTheme.navy)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 7)
                        .background(AppTheme.sun)

                    Spacer()

                    Text("\(QuitInsightLibrary.all.count) 条")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white.opacity(0.58))
                        .padding(.trailing, 24)
                }

                Text(insight.title)
                    .font(.system(size: 29, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 24)

                Rectangle()
                    .fill(AppTheme.teal)
                    .frame(width: 48, height: 5)
                    .padding(.vertical, 22)

                Text(insight.body)
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.84))
                    .lineSpacing(8)
                    .fixedSize(horizontal: false, vertical: true)

                Text("亚伦·卡尔戒烟理念 · 重新整理")
                    .font(.caption.weight(.bold))
                    .foregroundColor(AppTheme.teal)
                    .padding(.top, 24)
            }
            .padding(24)
        }
        .id(insight.id)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .transition(.opacity.combined(with: .scale(scale: 0.985)))
    }

    private var shuffleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                insight = QuitInsightLibrary.random(excluding: insight.id)
            }
        } label: {
            HStack {
                Image(systemName: "shuffle")
                Text("随机换一条")
                    .font(.headline.weight(.bold))
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .frame(height: 58)
            .background(AppTheme.coral)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
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
