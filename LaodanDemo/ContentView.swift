import Foundation
import SwiftUI

struct ContentView: View {
    @AppStorage("quitStartTimestamp") private var startTimestamp: Double = 0
    @AppStorage("dailyCigaretteCount") private var dailyCount: Int = 0
    @AppStorage("cigarettePackPrice") private var packPrice: Double = 0

    var body: some View {
        Group {
            if startTimestamp > 0 && dailyCount > 0 && packPrice > 0 {
                TabView {
                    DashboardView(
                        startDate: Date(timeIntervalSince1970: startTimestamp),
                        dailyCount: dailyCount,
                        packPrice: packPrice
                    )
                    .tabItem { Label("进度", systemImage: "chart.bar.xaxis") }

                    ReinforcementTabView()
                        .tabItem { Label("巩固", systemImage: "book") }

                    SettingsView(
                        startTimestamp: $startTimestamp,
                        dailyCount: $dailyCount,
                        packPrice: $packPrice
                    )
                    .tabItem { Label("设置", systemImage: "slider.horizontal.3") }
                }
            } else {
                StartSetupView(
                    startTimestamp: $startTimestamp,
                    dailyCount: $dailyCount,
                    packPrice: $packPrice
                )
            }
        }
        .tint(AppTheme.accent)
        .preferredColorScheme(.light)
    }
}

enum AppTheme {
    static let page = Color(red: 0.97, green: 0.975, blue: 0.97)
    static let ink = Color(red: 0.18, green: 0.23, blue: 0.28)
    static let muted = Color(red: 0.40, green: 0.45, blue: 0.49)
    static let accent = Color(red: 0.22, green: 0.40, blue: 0.58)
    static let blue = Color(red: 0.90, green: 0.94, blue: 0.98)
    static let green = Color(red: 0.89, green: 0.95, blue: 0.91)
    static let greenInk = Color(red: 0.22, green: 0.43, blue: 0.33)
    static let peach = Color(red: 0.99, green: 0.93, blue: 0.86)
    static let peachInk = Color(red: 0.53, green: 0.36, blue: 0.21)
    static let lavender = Color(red: 0.94, green: 0.92, blue: 0.98)
    static let lavenderInk = Color(red: 0.42, green: 0.35, blue: 0.56)
    static let line = Color(red: 0.89, green: 0.91, blue: 0.92)
}

struct PageHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 29, weight: .semibold))
                .foregroundColor(AppTheme.ink)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }
}

struct SoftPanel: ViewModifier {
    var color: Color = .white

    func body(content: Content) -> some View {
        content
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

extension View {
    func softPanel(_ color: Color = .white) -> some View {
        modifier(SoftPanel(color: color))
    }
}

private struct DashboardView: View {
    let startDate: Date
    let dailyCount: Int
    let packPrice: Double
    @Environment(\.sizeCategory) private var sizeCategory

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let duration = ElapsedTime(from: startDate, to: context.date)
            let milestone = Milestone.current(for: duration.days)
            let avoided = max(0, context.date.timeIntervalSince(startDate)) / 86_400 * Double(dailyCount)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    PageHeading(title: "鱼头戒烟", subtitle: "每一天，都算数。")
                    durationPanel(duration, milestone: milestone)

                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible(), spacing: 14),
                            count: sizeCategory.isAccessibilityCategory ? 1 : 2
                        ),
                        spacing: 14
                    ) {
                        metric(
                            title: "累计节省",
                            value: "¥" + MoneyText.amount(avoided / 20 * packPrice),
                            detail: "根据以往烟量估算",
                            symbol: "creditcard",
                            surface: AppTheme.green,
                            ink: AppTheme.greenInk
                        )
                        metric(
                            title: "少抽香烟",
                            value: "\(Int(avoided))",
                            detail: "根 · 从开始至今",
                            symbol: "leaf",
                            surface: AppTheme.peach,
                            ink: AppTheme.peachInk
                        )
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .foregroundColor(AppTheme.lavenderInk)
                            .font(.system(size: 18))
                            .frame(width: 42, height: 42)
                            .background(AppTheme.lavender)
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                        VStack(alignment: .leading, spacing: 5) {
                            Text("戒烟开始于")
                                .font(.caption)
                                .foregroundColor(AppTheme.muted)
                            Text(DateText.string(startDate))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 4)

                    Text("按每日 \(dailyCount) 根、每盒 ¥\(MoneyText.price(packPrice)) 估算，每盒 20 根。")
                        .font(.caption)
                        .foregroundColor(AppTheme.muted)
                        .lineSpacing(3)
                        .padding(.horizontal, 4)
                }
                .frame(maxWidth: 580)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
            .background(AppTheme.page.ignoresSafeArea())
        }
    }

    private func durationPanel(_ time: ElapsedTime, milestone: Milestone) -> some View {
        VStack(spacing: 22) {
            HStack {
                Label("戒烟时长", systemImage: "clock")
                    .foregroundColor(AppTheme.muted)
                Spacer()
                HStack(spacing: 6) {
                    Circle().fill(AppTheme.greenInk).frame(width: 5, height: 5)
                    Text("持续记录")
                }
                .foregroundColor(AppTheme.greenInk)
            }
            .font(.caption.weight(.medium))

            VStack(spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(time.days)")
                        .font(.system(size: 86, weight: .light, design: .rounded))
                        .tracking(-3)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                    Text("天")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.muted)
                }
                .foregroundColor(AppTheme.ink)
                .accessibilityElement(children: .combine)
                Text("已经走过的无烟日子")
                    .font(.caption)
                    .foregroundColor(AppTheme.muted)
            }
            .padding(.vertical, 4)

            HStack(spacing: 10) {
                timeCell(time.hours, label: "小时")
                timeCell(time.minutes, label: "分钟")
                timeCell(time.seconds, label: "秒")
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("下个里程碑 · \(milestone.target) 天")
                        .foregroundColor(AppTheme.ink)
                    Spacer()
                    Text("还差 \(milestone.remaining) 天")
                        .foregroundColor(AppTheme.muted)
                }
                .font(.caption)
                ProgressView(value: milestone.progress)
                    .tint(AppTheme.accent)
                    .scaleEffect(x: 1, y: 1.4)
                    .accessibilityLabel("距离下个里程碑的进度")
            }
        }
        .softPanel()
    }

    private func timeCell(_ value: Int, label: String) -> some View {
        VStack(spacing: 5) {
            Text(String(format: "%02d", value))
                .font(.system(size: 23, weight: .medium, design: .rounded))
                .monospacedDigit()
                .foregroundColor(AppTheme.accent)
            Text(label).font(.caption2).foregroundColor(AppTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(AppTheme.blue.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .accessibilityElement(children: .combine)
    }

    private func metric(title: String, value: String, detail: String,
                        symbol: String, surface: Color, ink: Color) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .regular))
            Text(title)
                .font(.subheadline.weight(.medium))
            Text(value)
                .font(.system(size: 29, weight: .medium, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .accessibilityLabel("\(title)，\(value)")
            Text(detail)
                .font(.caption2)
                .foregroundColor(ink.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(ink)
        .frame(maxWidth: .infinity, alignment: .leading)
        .softPanel(surface)
    }
}

private struct StartSetupView: View {
    @Binding var startTimestamp: Double
    @Binding var dailyCount: Int
    @Binding var packPrice: Double
    @State private var selectedDate: Date
    @State private var draftDaily: Int
    @State private var draftPrice: Double

    init(startTimestamp: Binding<Double>, dailyCount: Binding<Int>, packPrice: Binding<Double>) {
        _startTimestamp = startTimestamp
        _dailyCount = dailyCount
        _packPrice = packPrice
        _selectedDate = State(initialValue: startTimestamp.wrappedValue > 0
            ? Date(timeIntervalSince1970: startTimestamp.wrappedValue) : Date())
        _draftDaily = State(initialValue: dailyCount.wrappedValue > 0 ? dailyCount.wrappedValue : 20)
        _draftPrice = State(initialValue: packPrice.wrappedValue > 0 ? packPrice.wrappedValue : 20)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Label("鱼头戒烟", systemImage: "leaf")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(AppTheme.greenInk)
                    .padding(.top, 12)
                PageHeading(
                    title: startTimestamp > 0 ? "完善你的记录" : "从这一天开始",
                    subtitle: startTimestamp > 0 ? "补充烟量与价格，看看已经省下多少。" : "选择戒烟时间，留下你的第一笔记录。"
                )
                VStack(alignment: .leading, spacing: 18) {
                    Label("开始时间", systemImage: "calendar")
                        .font(.headline).foregroundColor(AppTheme.accent)
                    ChineseDateTimePicker(selection: $selectedDate)
                }
                .softPanel()

                SmokingProfileEditor(dailyCount: $draftDaily, packPrice: $draftPrice)
                    .softPanel(AppTheme.green.opacity(0.6))

                Button {
                    startTimestamp = min(selectedDate, Date()).timeIntervalSince1970
                    dailyCount = draftDaily
                    packPrice = draftPrice
                } label: {
                    Text("保存并开始记录")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .foregroundColor(.white)
                        .background(AppTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                Label("保存在本机，随时可以修改", systemImage: "lock")
                    .font(.caption)
                    .foregroundColor(AppTheme.muted)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 580)
            .frame(maxWidth: .infinity)
            .padding(22)
        }
        .background(AppTheme.page.ignoresSafeArea())
    }
}

private struct SmokingProfileEditor: View {
    @Binding var dailyCount: Int
    @Binding var packPrice: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("以前的吸烟习惯")
                .font(.headline).foregroundColor(AppTheme.ink)
            Text("用于估算省下的钱，修改后会重新计算。")
                .font(.caption).foregroundColor(AppTheme.muted)
            Stepper(value: $dailyCount, in: 1...100) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("每日烟量").font(.subheadline).foregroundColor(AppTheme.muted)
                    Text("\(dailyCount) 根").font(.title3.weight(.medium)).foregroundColor(AppTheme.ink)
                }
            }
            Divider()
            Stepper(value: $packPrice, in: 1...500, step: 0.5) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("每盒价格 · 20 根").font(.subheadline).foregroundColor(AppTheme.muted)
                    Text("¥\(MoneyText.price(packPrice))")
                        .font(.title3.weight(.medium)).foregroundColor(AppTheme.ink)
                }
            }
        }
        .monospacedDigit()
    }
}

private struct SettingsView: View {
    @Binding var startTimestamp: Double
    @Binding var dailyCount: Int
    @Binding var packPrice: Double
    @State private var editing = false
    @State private var resetting = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                PageHeading(title: "设置", subtitle: "按自己的节奏，调整记录。")
                Button {
                    editing = true
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(AppTheme.accent)
                            .frame(width: 44, height: 44)
                            .background(AppTheme.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack(alignment: .leading, spacing: 7) {
                            Text("戒烟开始时间")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(AppTheme.ink)
                            Text(DateText.string(Date(timeIntervalSince1970: startTimestamp)))
                                .font(.caption)
                                .foregroundColor(AppTheme.muted)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(AppTheme.muted)
                    }
                    .softPanel()
                }
                .buttonStyle(.plain)

                SmokingProfileEditor(dailyCount: $dailyCount, packPrice: $packPrice)
                    .softPanel()

                VStack(alignment: .leading, spacing: 16) {
                    Label("重新开始", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .foregroundColor(AppTheme.peachInk)
                    Text("清除开始时间，重新设置一次戒烟记录。")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                    Button("重置戒烟记录") { resetting = true }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppTheme.peachInk)
                        .padding(.vertical, 8)
                }
                .softPanel(AppTheme.peach.opacity(0.7))

                Label("所有数据仅保存在这台设备上", systemImage: "lock")
                    .font(.caption)
                    .foregroundColor(AppTheme.muted)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 580)
            .frame(maxWidth: .infinity)
            .padding(22)
        }
        .background(AppTheme.page.ignoresSafeArea())
        .sheet(isPresented: $editing) {
            EditStartDateView(startTimestamp: $startTimestamp)
        }
        .alert("重新开始记录？", isPresented: $resetting) {
            Button("取消", role: .cancel) { }
            Button("重置记录", role: .destructive) { startTimestamp = 0 }
        } message: {
            Text("当前开始时间将被清除。每日烟量和价格会保留，方便重新设置。")
        }
    }
}

private struct EditStartDateView: View {
    @Binding var startTimestamp: Double
    @State private var selectedDate: Date
    @Environment(\.dismiss) private var dismiss

    init(startTimestamp: Binding<Double>) {
        _startTimestamp = startTimestamp
        _selectedDate = State(initialValue: Date(timeIntervalSince1970: startTimestamp.wrappedValue))
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    ChineseDateTimePicker(selection: $selectedDate).softPanel()
                    Text("保存后，戒烟时长和累计省钱会立即重新计算。")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.muted)
                    Button {
                        startTimestamp = min(selectedDate, Date()).timeIntervalSince1970
                        dismiss()
                    } label: {
                        Text("保存时间")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(AppTheme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .frame(maxWidth: 580)
                .frame(maxWidth: .infinity)
                .padding(22)
            }
            .background(AppTheme.page.ignoresSafeArea())
            .navigationTitle("修改戒烟时间")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
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
            Text("年 / 月 / 日").font(.subheadline.weight(.medium))
            DatePicker("选择年月日", selection: $selection,
                       in: DatePickerLimits.earliest...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .frame(height: 145)
                .clipped()
            Divider()
            Text("时 / 分").font(.subheadline.weight(.medium))
            DatePicker("选择时分", selection: $selection, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .frame(height: 115)
                .clipped()
        }
        .foregroundColor(AppTheme.ink)
        .environment(\.locale, Locale(identifier: "zh_CN"))
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

private enum MoneyText {
    static func amount(_ value: Double) -> String { String(format: "%.2f", value) }
    static func price(_ value: Double) -> String {
        value.rounded() == value ? String(format: "%.0f", value) : String(format: "%.1f", value)
    }
}

private enum DateText {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter
    }()
    static func string(_ date: Date) -> String { formatter.string(from: date) }
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
        return Milestone(target: target, remaining: max(0, target - days),
                         progress: min(1, max(0, Double(days - previous) / Double(span))))
    }
}

private struct ElapsedTime {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int

    init(from startDate: Date, to currentDate: Date) {
        let seconds = max(0, Int(currentDate.timeIntervalSince(startDate)))
        self.days = seconds / 86_400
        self.hours = seconds % 86_400 / 3_600
        self.minutes = seconds % 3_600 / 60
        self.seconds = seconds % 60
    }
}
