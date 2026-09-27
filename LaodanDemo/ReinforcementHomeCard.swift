import Foundation
import SwiftUI

struct ReinforcementTabView: View {
    @State private var insight = QuitInsightLibrary.random()

    private let accent = Color(red: 0.07, green: 0.43, blue: 0.34)
    private let deepGreen = Color(red: 0.035, green: 0.18, blue: 0.17)
    private let highlight = Color(red: 0.73, green: 0.91, blue: 0.65)
    private let pageBackground = Color(red: 0.955, green: 0.965, blue: 0.95)
    private let ink = Color(red: 0.08, green: 0.12, blue: 0.12)
    private let secondaryText = Color(red: 0.38, green: 0.43, blue: 0.42)

    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    insightCard
                    shuffleButton

                    Text("内容按《这书能让你戒烟》的章节与核心论证重新整理，不是原书逐字摘录。")
                        .font(.caption)
                        .foregroundColor(secondaryText)
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
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(accent)
                    .frame(width: 50, height: 50)

                Image(systemName: "book.closed.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("今日巩固")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(ink)

                Text("一次读懂一个观点")
                    .font(.subheadline)
                    .foregroundColor(secondaryText)
            }

            Spacer()
        }
    }

    private var insightCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(insight.category)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(highlight)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(Color.white.opacity(0.11))
                    .clipShape(Capsule())

                Spacer()

                Text("\(QuitInsightLibrary.all.count) 条观点")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white.opacity(0.66))
            }

            Text(insight.title)
                .font(.system(size: 29, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 24)

            Rectangle()
                .fill(Color.white.opacity(0.14))
                .frame(height: 1)
                .padding(.vertical, 22)

            Text(insight.body)
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.86))
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Image(systemName: "quote.opening")
                    .font(.caption.weight(.bold))
                Text("亚伦·卡尔戒烟理念")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(highlight.opacity(0.9))
            .padding(.top, 24)
        }
        .id(insight.id)
        .padding(24)
        .background(
            LinearGradient(
                colors: [deepGreen, accent],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: deepGreen.opacity(0.2), radius: 24, y: 14)
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
                    .font(.headline)
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(ink)
            .padding(.horizontal, 20)
            .frame(height: 58)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 19, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            }
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
