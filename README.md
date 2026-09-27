# 鱼头戒烟 / Yutou Quit Smoking

一款简洁、专注的 iOS 戒烟记录工具。它帮助你记录戒烟开始时间，实时查看已经坚持的时长和累计节省的金额，并通过持续巩固戒烟认知，让每一天的进步都清晰可见。

A clean and focused iOS quit-smoking tracker. It records when your smoke-free journey began, shows your progress and estimated savings in real time, and provides reinforcement content to help you stay committed.

## 中文介绍

### 主要功能

- **首次启动引导**：首次使用时设置戒烟开始日期和时间、每日烟量，以及每盒香烟的价格。
- **实时戒烟计时**：按天、小时、分钟和秒持续显示已经戒烟的时长。
- **累计省钱统计**：根据每日烟量和每盒价格自动计算截至当前累计节省的金额；每盒按 20 根计算。
- **进度首页**：集中展示戒烟时长、开始时间和省钱成果。
- **每日巩固**：从戒烟认知内容中随机展示一条观点，可以点开阅读详细解释，也可以切换下一条。
- **随时修改设置**：在设置页修改戒烟时间、每日烟量和每盒价格。
- **重新开始**：需要重新记录时，可以清除当前进度并重新设置。
- **中文日期体验**：日期和时间选择采用中文显示，更直观地呈现“11月12日”一类日期。
- **本地保存**：戒烟时间和个人烟量数据保存在设备本地，无须注册账号。

### 页面结构

应用包含三个主要页面：

1. **进度**：查看实时戒烟时长、开始时间和累计节省金额。
2. **巩固**：阅读戒烟认知内容，帮助自己保持清醒和坚定。
3. **设置**：修改戒烟时间、每日烟量、每盒价格，或重新开始记录。

### 省钱计算方式

```text
累计节省金额 = 已戒烟天数 × 每日烟量 ÷ 20 × 每盒价格
```

应用按实际经过的秒数连续计算，因此首页金额会实时更新。

## English

### Key Features

- **First-launch setup**: Choose your quit date and time, daily cigarette consumption, and price per pack.
- **Live smoke-free timer**: Track your progress continuously in days, hours, minutes, and seconds.
- **Savings tracker**: Estimate how much money you have saved based on your daily consumption and pack price. One pack is treated as 20 cigarettes.
- **Progress dashboard**: See your smoke-free duration, start time, and total savings in one place.
- **Daily reinforcement**: Read a randomly selected quit-smoking insight, open its detailed explanation, and switch to another insight whenever needed.
- **Editable settings**: Change the quit time, daily cigarette count, or pack price at any time.
- **Restart support**: Clear the current record and begin again when necessary.
- **Chinese-friendly date UI**: Dates are presented in a clear Chinese format instead of English month abbreviations.
- **Local storage**: Your quit date and smoking profile are stored locally on the device. No account is required.

### App Navigation

The app contains three main tabs:

1. **Progress**: View the live smoke-free timer, start time, and accumulated savings.
2. **Reinforcement**: Read practical ideas that strengthen your decision to remain smoke-free.
3. **Settings**: Edit the quit time and smoking profile, or restart your progress.

### Savings Formula

```text
Total savings = Smoke-free days × Cigarettes per day ÷ 20 × Price per pack
```

The calculation uses the exact elapsed time, so the amount shown on the dashboard updates continuously.

## 技术信息 / Technical Information

- SwiftUI
- Swift 5
- iOS 15.0+
- iPhone 与 iPad / iPhone and iPad
- 使用 `AppStorage` 在本地保存数据 / Local persistence with `AppStorage`
- GitHub Actions 自动构建 / Automated builds with GitHub Actions

## 构建无签名 IPA / Build an Unsigned IPA

仓库中的 GitHub Actions 工作流会在代码更新后自动使用 macOS 构建环境生成无签名 IPA：

1. 打开仓库的 **Actions** 页面。
2. 选择最新一次 **Build unsigned IPA** 任务。
3. 等待任务显示成功。
4. 在 **Artifacts** 区域下载 `QuitSmokingDuration-unsigned-*`。
5. 解压 ZIP 后即可获得 IPA 文件。

The included GitHub Actions workflow automatically builds an unsigned IPA on a macOS runner whenever the source code is updated:

1. Open the repository's **Actions** page.
2. Select the latest **Build unsigned IPA** run.
3. Wait for the workflow to complete successfully.
4. Download `QuitSmokingDuration-unsigned-*` from the **Artifacts** section.
5. Extract the ZIP archive to obtain the IPA file.

> 无签名 IPA 不能像 App Store 应用一样直接安装。安装到真机前仍需使用你自己的证书签名，或通过支持的侧载工具进行处理。
>
> An unsigned IPA cannot be installed like an App Store app. It must be signed with your own certificate or processed with a compatible sideloading tool before installation on a physical device.

## 数据与隐私 / Data and Privacy

本应用不要求登录，也不会把戒烟记录上传到服务器。当前数据通过 iOS 本地存储保存在设备上。卸载应用或清除应用数据可能会导致记录丢失。

The app does not require an account and does not upload your quit-smoking records to a server. Current data is stored locally on the device using iOS storage. Uninstalling the app or clearing its data may remove your records.

---

愿每一次打开应用，都能提醒你：你不是在失去什么，而是在把自由、健康和时间重新拿回来。

May every visit remind you that you are not giving something up—you are taking back your freedom, health, and time.
