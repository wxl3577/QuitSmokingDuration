import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundStyle(.white)

                Text("Laodan iOS Demo")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text("GitHub Actions 自动构建")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.85))

                VStack(spacing: 16) {
                    Text("按钮已点击 \(count) 次")
                        .font(.title3.weight(.medium))

                    Button {
                        count += 1
                    } label: {
                        Label("点击测试", systemImage: "hand.tap.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)

                    Button("重置") {
                        count = 0
                    }
                    .disabled(count == 0)
                }
                .padding(24)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 24)
            }
        }
    }
}
