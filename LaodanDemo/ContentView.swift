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

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            let elapsed = ElapsedTime(from: Self.startDate, to: timeline.date)

            ZStack {
                background

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        header
                        dayCard(days: elapsed.days)
                        timeCards(elapsed: elapsed)
                        startCard
                        encouragement
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 32)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.035, green: 0.075, blue: 0.105),
                    Color(red: 0.035, green: 0.145, blue: 0.145),
                    Color(red: 0.025, green: 0.055, blue: 0.085)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.teal.opacity(0.20))
                .frame(width: 280, height: 280)
                .blur(radius: 70)
                .offset(x: 150, y: -280)

            Circle()
                .fill(Color.orange.opacity(0.12))
                .frame(width: 240, height: 240)
                .blur(radius: 75)
                .offset(x: -170, y: 310)
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.teal, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: "lungs.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("戒烟时长")
                    .font(.title2.bold())
                Text("记录每一次自由呼吸")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.58))
            }

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(Color.mint)
                    .frame(width: 7, height: 7)
                    .shadow(color: .mint, radius: 5)
                Text("进行中")
                    .font(.caption.weight(.semibold))
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(.white.opacity(0.08), in: Capsule())
        }
    }

    private func dayCard(days: Int) -> some View {
        VStack(spacing: 12) {
            Text("已经坚持")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.62))

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("\(days)")
                    .font(.system(size: 82, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.55)
                Text("天")
                    .font(.title2.bold())
                    .foregroundStyle(.mint)
            }

            Label("你正在持续赢回健康", systemImage: "heart.fill")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.mint)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            LinearGradient(
                colors: [.white.opacity(0.14), .white.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.13), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.22), radius: 24, y: 14)
    }

    private func timeCards(elapsed: ElapsedTime) -> some View {
        HStack(spacing: 12) {
            TimeUnitCard(value: elapsed.hours, unit: "时")
            TimeUnitCard(value: elapsed.minutes, unit: "分")
            TimeUnitCard(value: elapsed.seconds, unit: "秒", highlighted: true)
        }
    }

    private var startCard: some View {
        HStack(spacing: 15) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(.orange)
                .frame(width: 48, height: 48)
                .background(Color.orange.opacity(0.14), in: RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 5) {
                Text("开始戒烟")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
                Text("2025年11月12日 22:51")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
    }

    private var encouragement: some View {
        VStack(spacing: 8) {
            Image(systemName: "leaf.fill")
                .font(.title3)
                .foregroundStyle(.mint)
            Text("每一个清醒的呼吸，\n都在让身体变得更自由。")
                .font(.footnote.weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.58))
                .lineSpacing(4)
        }
        .padding(.top, 4)
    }
}

private struct TimeUnitCard: View {
    let value: Int
    let unit: String
    var highlighted = false

    var body: some View {
        VStack(spacing: 7) {
            Text(String(format: "%02d", value))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text(unit)
                .font(.caption.weight(.semibold))
                .foregroundStyle(highlighted ? Color.mint : .white.opacity(0.52))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            highlighted ? Color.teal.opacity(0.20) : Color.white.opacity(0.07),
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(highlighted ? Color.mint.opacity(0.25) : .white.opacity(0.07), lineWidth: 1)
        }
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

