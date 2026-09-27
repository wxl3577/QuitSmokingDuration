import Foundation
import SwiftUI

struct ContentView: View {
    @AppStorage("quitStartTimestamp") private var quitStartTimestamp: Double = 0
    @AppStorage("dailyCigaretteCount") private var dailyCigaretteCount: Int = 0
    @AppStorage("cigarettePackPrice") private var cigarettePackPrice: Double = 0

    var body: some View {
        Group {
            if quitStartTimestamp > 0 && dailyCigaretteCount > 0 && cigarettePackPrice > 0 {
                MainTabView(
                    startTimestamp: $quitStartTimestamp,
                    dailyCigaretteCount: $dailyCigaretteCount,
                    cigarettePackPrice: $cigarettePackPrice
                )
            } else {
                StartSetupView(
                    startTimestamp: $quitStartTimestamp,
                    dailyCigaretteCount: $dailyCigaretteCount,
                    cigarettePackPrice: $cigarettePackPrice
                )
            }
        }
        .preferredColorScheme(.light)
    }
}

private struct MainTabView: View {
    @Binding var startTimestamp: Double
    @Binding var dailyCigaretteCount: Int
    @Binding var cigarettePackPrice: Double

    var body: some View {
        TabView {
            DashboardView(
                startDate: Date(timeIntervalSince1970: startTimestamp),
                dailyCigaretteCount: dailyCigaretteCount,
                cigarettePackPrice: cigarettePackPrice
            )
                .tabItem {
                    Label("进度", systemImage: "chart.bar.fill")
                }

            ReinforcementTabView()
                .tabItem {
                    Label("巩固", systemImage: "book.closed.fill")
                }

            SettingsView(
                startTimestamp: $startTimestamp,
                dailyCigaretteCount: $dailyCigaretteCount,
                cigarettePackPrice: $cigarettePackPrice
            )
                .tabItem {
                    Label("设置", systemImage: "slider.horizontal.3")
                }
        }
        .accentColor(AppTheme.accent)
    }
}

private struct StartSetupView: View {
    @Binding var startTimestamp: Double
    @Binding var dailyCigaretteCount: Int
    @Binding var cigarettePackPrice: Double
    @State private var selectedDate: Date
    @State private var draftDailyCount: Int
    @State private var draftPackPrice: Double

    init(
        startTimestamp: Binding<Double>,
        dailyCigaretteCount: Binding<Int>,
        cigarettePackPrice: Binding<Double>
    ) {
        _startTimestamp = startTimestamp
        _dailyCigaretteCount = dailyCigaretteCount
        _cigarettePackPrice = cigarettePackPrice

        let savedTimestamp = startTimestamp.wrappedValue
        _selectedDate = State(
            initialValue: savedTimestamp > 0
                ? Date(timeIntervalSince1970: savedTimestamp)
                : Date()
        )
        _draftDailyCount = State(initialValue: max(dailyCigaretteCount.wrappedValue, 20))
        _draftPackPrice = State(initialValue: max(cigarettePackPrice.wrappedValue, 20))
    }

    var body: some View {
        ZStack {
            AppTheme.pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    setupHero

                    VStack(alignment: .leading, spacing: 18) {
                        sectionTitle(index: "01", title: "选择开始时间", color: AppTheme.teal)
                        ChineseDateTimePicker(selection: $selectedDate)
                    }
                    .padding(22)
                    .background(AppTheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(AppTheme.teal)
                            .frame(width: 5)
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        sectionTitle(index: "02", title: "填写过去的习惯", color: AppTheme.sun)

                        Stepper(value: $draftDailyCount, in: 1...100) {
                            settingRow(
                                title: "每日烟量",
                                detail: "按每天平均数量填写",
                                value: "\(draftDailyCount) 根",
                                color: AppTheme.coral
                            )
                        }

                        Rectangle().fill(AppTheme.line).frame(height: 1)

                        Stepper(value: $draftPackPrice, in: 1...500, step: 0.5) {
                            settingRow(
                                title: "每盒价格",
                                detail: "每盒按 20 根计算",
                                value: "¥\(MoneyText.price(draftPackPrice))",
                                color: AppTheme.teal
                            )
                        }
                    }
                    .padding(22)
                    .background(AppTheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(AppTheme.sun)
                            .frame(width: 5)
                    }

                    Button {
                        startTimestamp = selectedDate.timeIntervalSince1970
                        dailyCigaretteCount = draftDailyCount
                        cigarettePackPrice = draftPackPrice
                    } label: {
                        HStack {
                            Text(startTimestamp > 0 ? "保存并继续" : "开始我的无烟生活")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .frame(height: 60)
                        .background(AppTheme.coral)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    Label("数据只保存在这台设备上", systemImage: "lock.fill")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 36)
            }
        }
    }

    private var setupHero: some View {
        ZStack(alignment: .bottomTrailing) {
            AppTheme.navy

            Circle()
                .fill(AppTheme.coral)
                .frame(width: 124, height: 124)
                .offset(x: 42, y: 48)

            Circle()
                .fill(AppTheme.sun)
                .frame(width: 24, height: 24)
                .offset(x: -36, y: -28)

            VStack(alignment: .leading, spacing: 14) {
                Text("鱼头戒烟")
                    .font(.system(size: 14, weight: .bold))
                    .tracking(3)
                    .foregroundColor(AppTheme.sun)

                Text(startTimestamp > 0 ? "补全信息，\n继续向前。" : "把戒烟，\n变成看得见的进步。")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(startTimestamp > 0
                    ? "填写烟量和价格后，首页会立即计算累计节省。"
                    : "从一个明确的时间开始，记录每一天、每一笔节省。")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.72))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, 54)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .frame(minHeight: 250)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func sectionTitle(index: String, title: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Text(index)
                .font(.caption.weight(.black))
                .foregroundColor(AppTheme.navy)
                .frame(width: 34, height: 28)
                .background(color)

            Text(title)
                .font(.headline)
                .foregroundColor(AppTheme.ink)
        }
    }

    private func settingRow(title: String, detail: String, value: String, color: Color) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(AppTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }

            Spacer()

            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundColor(color)
        }
    }
}

private struct DashboardView: View {
    let startDate: Date
    let dailyCigaretteCount: Int
    let cigarettePackPrice: Double

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
                        savingsCard(asOf: timeline.date)
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
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(AppTheme.coral)
                        .frame(width: 22, height: 5)

                    Text("鱼头戒烟")
                        .font(.caption.weight(.black))
                        .tracking(2.5)
                        .foregroundColor(AppTheme.coral)
                }

                Text("无烟进度")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.ink)
            }

            Spacer()

            Text("LIVE")
                .font(.caption2.weight(.black))
                .tracking(1.5)
                .foregroundColor(AppTheme.navy)
                .padding(.horizontal, 11)
                .padding(.vertical, 7)
                .background(AppTheme.sun)
        }
    }

    private func durationCard(_ elapsed: ElapsedTime) -> some View {
        ZStack(alignment: .topTrailing) {
            AppTheme.navy

            Circle()
                .fill(AppTheme.teal)
                .frame(width: 112, height: 112)
                .offset(x: 42, y: -46)

            Circle()
                .fill(AppTheme.coral)
                .frame(width: 34, height: 34)
                .offset(x: -26, y: 42)

            VStack(alignment: .leading, spacing: 0) {
                Text("已经坚持")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white.opacity(0.68))

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text("\(elapsed.days)")
                        .font(.system(size: 88, weight: .black, design: .rounded))
                        .tracking(-4)
                        .monospacedDigit()
                        .minimumScaleFactor(0.52)
                        .lineLimit(1)

                    Text("天")
                        .font(.title2.weight(.black))
                        .foregroundColor(AppTheme.sun)
                }
                .foregroundColor(.white)
                .padding(.top, 3)

                HStack(spacing: 0) {
                    TimeValue(value: elapsed.hours, label: "小时", light: true)
                    lightDivider
                    TimeValue(value: elapsed.minutes, label: "分钟", light: true)
                    lightDivider
                    TimeValue(value: elapsed.seconds, label: "秒", light: true)
                }
                .padding(.top, 20)
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var lightDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(width: 1, height: 34)
    }

    private func savingsCard(asOf now: Date) -> some View {
        let elapsedSeconds = max(0, now.timeIntervalSince(startDate))
        let avoidedCigarettes = elapsedSeconds / 86_400 * Double(dailyCigaretteCount)
        let savedMoney = avoidedCigarettes / 20 * cigarettePackPrice

        return VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("累计省下")
                    .font(.caption.weight(.black))
                    .tracking(2)
                    .foregroundColor(AppTheme.navy.opacity(0.72))

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(AppTheme.coral)
                    .frame(width: 38, height: 38)
                    .background(AppTheme.navy)
                    .clipShape(Circle())
            }

            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("¥")
                    .font(.title2.weight(.black))
                    .foregroundColor(AppTheme.navy.opacity(0.7))

                Text(MoneyText.amount(savedMoney))
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(AppTheme.navy)
                    .minimumScaleFactor(0.65)
                    .lineLimit(1)
            }

            Text("按每日 \(dailyCigaretteCount) 根、每盒 ¥\(MoneyText.price(cigarettePackPrice))（20根）计算")
                .font(.caption)
                .foregroundColor(AppTheme.navy.opacity(0.7))
        }
        .padding(22)
        .background(AppTheme.sun)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func milestoneCard(_ milestone: Milestone) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("NEXT / 下一个目标")
                        .font(.caption.weight(.black))
                        .tracking(1.2)
                        .foregroundColor(AppTheme.teal)
                    Text("坚持到 \(milestone.target) 天")
                        .font(.title3.weight(.black))
                        .foregroundColor(AppTheme.ink)
                }

                Spacer()

                Text("\(Int(milestone.progress * 100))%")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(AppTheme.coral)
            }

            ProgressView(value: milestone.progress)
                .tint(AppTheme.teal)
                .scaleEffect(x: 1, y: 2.2, anchor: .center)

            Text("还差 \(milestone.remaining) 天。不用冲刺，只要不回头。")
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
        }
        .padding(22)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(alignment: .top) {
            Rectangle().fill(AppTheme.teal).frame(height: 5)
        }
    }

    private var startDateCard: some View {
        HStack(spacing: 15) {
            Image(systemName: "calendar")
                .font(.system(size: 18, weight: .black))
                .foregroundColor(AppTheme.navy)
                .frame(width: 42, height: 42)
                .background(AppTheme.coral)
                .clipShape(Circle())

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
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct SettingsView: View {
    @Binding var startTimestamp: Double
    @Binding var dailyCigaretteCount: Int
    @Binding var cigarettePackPrice: Double
    @State private var draftDate: Date
    @State private var isEditingStartDate = false
    @State private var showSavedNotice = false
    @State private var showResetConfirmation = false

    init(
        startTimestamp: Binding<Double>,
        dailyCigaretteCount: Binding<Int>,
        cigarettePackPrice: Binding<Double>
    ) {
        _startTimestamp = startTimestamp
        _dailyCigaretteCount = dailyCigaretteCount
        _cigarettePackPrice = cigarettePackPrice
        _draftDate = State(initialValue: Date(timeIntervalSince1970: startTimestamp.wrappedValue))
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        settingsCard
                        smokingProfileCard
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
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(AppTheme.navy)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.sun)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("开始戒烟时间")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("修改后，统计会立即重新计算")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.62))
                }
            }

            Rectangle().fill(Color.white.opacity(0.14)).frame(height: 1)

            VStack(alignment: .leading, spacing: 6) {
                Text("当前开始时间")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.58))

                Text(DateTextFormatter.string(from: Date(timeIntervalSince1970: startTimestamp)))
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.white)
            }

            Button {
                draftDate = Date(timeIntervalSince1970: startTimestamp)
                isEditingStartDate = true
            } label: {
                Label("修改戒烟时间", systemImage: "pencil")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppTheme.coral)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(22)
        .background(AppTheme.navy)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var smokingProfileCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 13) {
                Image(systemName: "banknote.fill")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(AppTheme.navy)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.teal)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("省钱计算设置")
                        .font(.headline)
                        .foregroundColor(AppTheme.ink)
                    Text("修改后，首页金额会立即重新计算")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }

            Rectangle().fill(AppTheme.line).frame(height: 1)

            Stepper(value: $dailyCigaretteCount, in: 1...100) {
                HStack {
                    Text("每日烟量")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppTheme.ink)
                    Spacer()
                    Text("\(dailyCigaretteCount) 根")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(AppTheme.coral)
                }
            }

            Rectangle().fill(AppTheme.line).frame(height: 1)

            Stepper(value: $cigarettePackPrice, in: 1...500, step: 0.5) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("每盒价格")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(AppTheme.ink)
                        Text("每盒按20根")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    Spacer()
                    Text("¥\(MoneyText.price(cigarettePackPrice))")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(AppTheme.teal)
                }
            }
        }
        .padding(22)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(alignment: .top) {
            Rectangle().fill(AppTheme.teal).frame(height: 5)
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
                    .foregroundColor(AppTheme.coral)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.coral.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(20)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(alignment: .leading) {
                            Rectangle().fill(AppTheme.teal).frame(width: 5)
                        }

                    Spacer(minLength: 0)

                    Button {
                        onSave()
                        dismiss()
                    } label: {
                        Text("保存并重新计算")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(AppTheme.coral)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
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
                .font(.system(size: 27, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundColor(light ? .white : AppTheme.ink)
            Text(label)
                .font(.caption)
                .foregroundColor(light ? .white.opacity(0.64) : AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

enum AppTheme {
    static let navy = Color(red: 0.055, green: 0.09, blue: 0.18)
    static let coral = Color(red: 0.96, green: 0.31, blue: 0.22)
    static let teal = Color(red: 0.10, green: 0.67, blue: 0.61)
    static let sun = Color(red: 0.98, green: 0.76, blue: 0.20)
    static let sky = Color(red: 0.31, green: 0.58, blue: 0.96)
    static let ink = Color(red: 0.07, green: 0.09, blue: 0.15)
    static let secondaryText = Color(red: 0.36, green: 0.38, blue: 0.43)
    static let pageBackground = Color(red: 0.965, green: 0.95, blue: 0.91)
    static let card = Color(red: 1.0, green: 0.995, blue: 0.98)
    static let line = Color(red: 0.88, green: 0.86, blue: 0.81)

    static let accent = coral
    static let deepGreen = navy
    static let highlight = sun
}

private enum MoneyText {
    static func amount(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    static func price(_ value: Double) -> String {
        value.rounded() == value
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
    }
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
