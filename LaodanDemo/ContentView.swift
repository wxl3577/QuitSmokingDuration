import SwiftUI

struct ContentView: View {
    @AppStorage("quitStartTimestamp") private var quitStartTimestamp: Double = 0

    var body: some View {
        Group {
            if quitStartTimestamp > 0 {
                MainTabView(startTimestamp: $quitStartTimestamp)
            } else {
                StartSetupView(startTimestamp: $quitStartTimestamp)
            }
        }
        .preferredColorScheme(.light)
    }
}

private struct MainTabView: View {
    @Binding var startTimestamp: Double

    var body: some View {
        TabView {
            DashboardView(startDate: Date(timeIntervalSince1970: startTimestamp))
                .tabItem {
                    Label("进度", systemImage: "chart.bar.fill")
                }

            SettingsView(startTimestamp: $startTimestamp)
                .tabItem {
                    Label("设置", systemImage: "slider.horizontal.3")
                }
        }
        .accentColor(AppTheme.accent)
    }
}

private struct StartSetupView: View {
    @Binding var startTimestamp: Double
    @State private var selectedDate = Date()

    var body: some View {
        ZStack {
            AppTheme.pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    Spacer(minLength: 32)

                    ZStack {
                        Circle()
                            .fill(AppTheme.accent.opacity(0.12))
                            .frame(width: 82, height: 82)

                        Image(systemName: "leaf.fill")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundColor(AppTheme.accent)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("鱼头戒烟")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.ink)

                        Text("先记录你的开始时间，之后每一秒都会被认真保存。")
                            .font(.system(size: 17))
                            .foregroundColor(AppTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(4)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        Label("我从这里开始", systemImage: "calendar.badge.clock")
                            .font(.headline)
                            .foregroundColor(AppTheme.ink)

                        ChineseDateTimePicker(selection: $selectedDate)
                    }
                    .padding(22)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    }
                    .shadow(color: Color.black.opacity(0.05), radius: 20, y: 10)

                    Button {
                        startTimestamp = selectedDate.timeIntervalSince1970
                    } label: {
                        HStack {
                            Text("开始记录")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .frame(height: 58)
                        .background(AppTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    Text("数据仅保存在你的设备中")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
            }
        }
    }
}

private struct DashboardView: View {
    let startDate: Date

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            let elapsed = ElapsedTime(from: startDate, to: timeline.date)
            let milestone = Milestone.current(for: elapsed.days)

            ZStack {
                AppTheme.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        header
                        durationCard(elapsed)
                        milestoneCard(milestone)
                        startDateCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 30)
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(AppTheme.accent)
                    .frame(width: 50, height: 50)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("鱼头戒烟")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.ink)

                Text("今天也比昨天更自由")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
            }

            Spacer()
        }
    }

    private func durationCard(_ elapsed: ElapsedTime) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("无烟生活")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white.opacity(0.72))

                Spacer()

                HStack(spacing: 6) {
                    Circle()
                        .fill(AppTheme.highlight)
                        .frame(width: 7, height: 7)
                    Text("进行中")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("\(elapsed.days)")
                    .font(.system(size: 82, weight: .bold, design: .rounded))
                    .tracking(-3)
                    .monospacedDigit()
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)

                Text("天")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(AppTheme.highlight)
            }
            .foregroundColor(.white)
            .padding(.top, 10)

            Rectangle()
                .fill(Color.white.opacity(0.14))
                .frame(height: 1)
                .padding(.vertical, 20)

            HStack(spacing: 0) {
                TimeValue(value: elapsed.hours, label: "小时", light: true)
                lightDivider
                TimeValue(value: elapsed.minutes, label: "分钟", light: true)
                lightDivider
                TimeValue(value: elapsed.seconds, label: "秒", light: true)
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [AppTheme.deepGreen, AppTheme.accent],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: AppTheme.deepGreen.opacity(0.2), radius: 24, y: 14)
    }

    private var lightDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(width: 1, height: 34)
    }

    private func milestoneCard(_ milestone: Milestone) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("下一个里程碑")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                    Text("坚持到 \(milestone.target) 天")
                        .font(.headline)
                        .foregroundColor(AppTheme.ink)
                }

                Spacer()

                Text("\(Int(milestone.progress * 100))%")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(AppTheme.accent)
            }

            ProgressView(value: milestone.progress)
                .tint(AppTheme.accent)
                .scaleEffect(x: 1, y: 1.8, anchor: .center)

            Text("还差 \(milestone.remaining) 天，保持现在的节奏。")
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
        }
        .padding(21)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.045), lineWidth: 1)
        }
    }

    private var startDateCard: some View {
        HStack(spacing: 15) {
            Image(systemName: "calendar")
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(AppTheme.accent)
                .frame(width: 44, height: 44)
                .background(AppTheme.accent.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text("开始时间")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
                Text(DateTextFormatter.string(from: startDate))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundColor(AppTheme.ink)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.045), lineWidth: 1)
        }
    }
}

private struct SettingsView: View {
    @Binding var startTimestamp: Double
    @State private var draftDate: Date
    @State private var isEditingStartDate = false
    @State private var showSavedNotice = false
    @State private var showResetConfirmation = false

    init(startTimestamp: Binding<Double>) {
        _startTimestamp = startTimestamp
        _draftDate = State(initialValue: Date(timeIntervalSince1970: startTimestamp.wrappedValue))
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        settingsCard
                        resetCard

                        Text("所有设置仅保存在这台设备上。")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("设置")
            .alert("已保存", isPresented: $showSavedNotice) {
                Button("好", role: .cancel) { }
            } message: {
                Text("新的开始时间已经生效。")
            }
            .alert("确定要重置吗？", isPresented: $showResetConfirmation) {
                Button("取消", role: .cancel) { }
                Button("重置记录", role: .destructive) {
                    startTimestamp = 0
                }
            } message: {
                Text("当前开始时间将被清除，下次需要重新设置。")
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            draftDate = Date(timeIntervalSince1970: startTimestamp)
        }
        .sheet(isPresented: $isEditingStartDate) {
            EditStartDateView(selectedDate: $draftDate) {
                startTimestamp = draftDate.timeIntervalSince1970
                showSavedNotice = true
                isEditingStartDate = false
            }
        }
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 13) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppTheme.accent)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.accent.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text("开始戒烟时间")
                        .font(.headline)
                        .foregroundColor(AppTheme.ink)
                    Text("修改后，统计会立即重新计算")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("当前开始时间")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)

                Text(DateTextFormatter.string(from: Date(timeIntervalSince1970: startTimestamp)))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(AppTheme.ink)
            }

            Button {
                draftDate = Date(timeIntervalSince1970: startTimestamp)
                isEditingStartDate = true
            } label: {
                Label("修改戒烟时间", systemImage: "pencil")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppTheme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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

    private var resetCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("重新开始")
                .font(.headline)
                .foregroundColor(AppTheme.ink)

            Text("清除当前记录，返回首次设置页面。此操作会先要求你确认。")
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                showResetConfirmation = true
            } label: {
                Label("重置戒烟记录", systemImage: "arrow.counterclockwise")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.red.opacity(0.82))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.red.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
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
}

private struct EditStartDateView: View {
    @Binding var selectedDate: Date
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.pageBackground.ignoresSafeArea()

                VStack(spacing: 18) {
                    ChineseDateTimePicker(selection: $selectedDate)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.black.opacity(0.045), lineWidth: 1)
                        }

                    Spacer(minLength: 0)

                    Button {
                        onSave()
                        dismiss()
                    } label: {
                        Text("保存并重新计算")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(AppTheme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                    }
                }
                .padding(20)
            }
            .navigationTitle("修改戒烟时间")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

private struct ChineseDateTimePicker: View {
    @Binding var selection: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("日期（上下滑动可选择年份）")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppTheme.ink)

            DatePicker(
                "选择年月日",
                selection: $selection,
                in: DatePickerLimits.earliest...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "zh_CN"))
            .accentColor(AppTheme.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 135)
            .clipped()

            Divider()

            Text("时间")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppTheme.ink)

            DatePicker(
                "选择时分",
                selection: $selection,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "zh_CN"))
            .accentColor(AppTheme.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .clipped()
        }
    }
}

private enum DatePickerLimits {
    static let earliest: Date = {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.year = 1900
        components.month = 1
        components.day = 1
        return components.date ?? .distantPast
    }()
}

private struct TimeValue: View {
    let value: Int
    let label: String
    let light: Bool

    var body: some View {
        VStack(spacing: 5) {
            Text(String(format: "%02d", value))
                .font(.system(size: 27, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(light ? .white : AppTheme.ink)
            Text(label)
                .font(.caption)
                .foregroundColor(light ? .white.opacity(0.64) : AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

private enum AppTheme {
    static let accent = Color(red: 0.07, green: 0.43, blue: 0.34)
    static let deepGreen = Color(red: 0.035, green: 0.18, blue: 0.17)
    static let highlight = Color(red: 0.73, green: 0.91, blue: 0.65)
    static let ink = Color(red: 0.08, green: 0.12, blue: 0.12)
    static let secondaryText = Color(red: 0.38, green: 0.43, blue: 0.42)
    static let pageBackground = Color(red: 0.955, green: 0.965, blue: 0.95)
}

private enum DateTextFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d号 HH时mm分"
        return formatter
    }()

    static func string(from date: Date) -> String {
        formatter.string(from: date)
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
