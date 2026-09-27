import SwiftUI

struct ContentView: View {
    private static let startDate: Date = {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)
        components.year = 2025
        components.month = 11
        components.day = 12
        components.hour = 22
        components.minute = 51
        components.second = 0
        return components.date!
    }()

    private let accent = Color(red: 0.12, green: 0.31, blue: 0.24)
    private let pageBackground = Color(red: 0.955, green: 0.952, blue: 0.935)

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            let elapsed = ElapsedTime(from: Self.startDate, to: timeline.date)
            let milestone = Milestone.current(for: elapsed.days)

            ZStack {
                pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        header
                        durationCard(elapsed)
                        milestoneCard(milestone)
                        startDateCard

                        Text("时间会在应用打开时持续更新")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 30)
                }
            }
        }
        .preferredColorScheme(.light)
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("戒烟时长")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.primary)

                Text("从决定开始，到现在")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 7) {
                Circle()
                    .fill(accent)
                    .frame(width: 7, height: 7)
                Text("记录中")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(accent)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(accent.opacity(0.08), in: Capsule())
        }
    }

    private func durationCard(_ elapsed: ElapsedTime) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("已经坚持")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(elapsed.days)")
                    .font(.system(size: 86, weight: .semibold, design: .default))
                    .tracking(-3)
                    .monospacedDigit()
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(Color.primary)

                Text("天")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(accent)
            }
            .padding(.top, 6)

            Rectangle()
                .fill(Color.primary.opacity(0.09))
                .frame(height: 1)
                .padding(.vertical, 22)

            HStack(spacing: 0) {
                TimeValue(value: elapsed.hours, label: "小时")
                divider
                TimeValue(value: elapsed.minutes, label: "分钟")
                divider
                TimeValue(value: elapsed.seconds, label: "秒")
            }
        }
        .padding(24)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.045), radius: 18, y: 8)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.08))
            .frame(width: 1, height: 34)
    }

    private func milestoneCard(_ milestone: Milestone) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("下一个里程碑")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(milestone.target) 天")
                    .font(.headline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(accent)
            }

            ProgressView(value: milestone.progress)
                .tint(accent)
                .scaleEffect(x: 1, y: 1.7, anchor: .center)

            HStack {
                Text("已完成 \(Int(milestone.progress * 100))%")
                Spacer()
                Text("还差 \(milestone.remaining) 天")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.045), lineWidth: 1)
        }
    }

    private var startDateCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "calendar")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(accent)
                .frame(width: 38, height: 38)
                .background(accent.opacity(0.08), in: RoundedRectangle(cornerRadius: 11, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text("开始时间")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("2025年11月12日 22:51")
                    .font(.subheadline.weight(.medium))
                    .monospacedDigit()
                    .foregroundStyle(Color.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.045), lineWidth: 1)
        }
    }
}

private struct TimeValue: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 5) {
            Text(String(format: "%02d", value))
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(Color.primary)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct Milestone {
    let target: Int
    let remaining: Int
    let progress: Double

    static func current(for days: Int) -> Milestone {
        let milestones = [1, 3, 7, 14, 30, 60, 90, 100, 180, 365, 500, 730, 1_000]
        let target = milestones.first(where: { $0 > days }) ?? ((days / 365) + 1) * 365
        let previous = milestones.last(where: { $0 <= days }) ?? 0
        let span = max(1, target - previous)
        let progress = min(1, max(0, Double(days - previous) / Double(span)))

        return Milestone(
            target: target,
            remaining: max(0, target - days),
            progress: progress
        )
    }
}

private struct ElapsedTime {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int

    init(from startDate: Date, to currentDate: Date) {
        let totalSeconds = max(0, Int(currentDate.timeIntervalSince(startDate)))
        days = totalSeconds / 86_400
        hours = (totalSeconds % 86_400) / 3_600
        minutes = (totalSeconds % 3_600) / 60
        seconds = totalSeconds % 60
    }
}
