import SwiftUI

struct MP3View: View {
    @ObservedObject var viewModel: MP3ViewModel
    
    var body: some View {
        VStack(spacing: 24) {

            // 🎯 볼륨 슬라이더 - 애니메이션 등장
            if viewModel.isPlaying {
                VStack(alignment: .leading, spacing: 12) {
                    Text("현재 트랙: \(viewModel.trackNumber)번")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.7))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                                .animation(.easeInOut(duration: 0.4), value: viewModel.trackNumber)
                                

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 20)

                        Capsule()
                            .fill(Color.cyan)
                            .frame(width: CGFloat(viewModel.volumeLevel) / 7.0 * 300, height: 20)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.volumeLevel)
                    }
                    .frame(width: 300)

                    Text("\(viewModel.volumeLevel) / 7")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.cyan)
                }
                .padding(.top, 10)
                .padding(.bottom, 5)
                .transition(.move(edge: .bottom).combined(with: .opacity)) // ⬅️ 자연스러운 이동 + 페이드 효과
                .animation(.easeInOut(duration: 0.5), value: viewModel.isPlaying)
            }

            // 🔘 볼륨 조절 버튼들
            if viewModel.isPlaying {
                HStack(spacing: 40) {
                    volumeButton(
                        image: "speaker.wave.1.fill",
                        label: "볼륨 -",
                        action: { viewModel.sendCommand(.volumeDown) }
                    )

                    volumeButton(
                        image: "shuffle",
                        label: "랜덤",
                        action: { viewModel.sendCommand(.random) }
                    )

                    volumeButton(
                        image: "speaker.wave.3.fill",
                        label: "볼륨 +",
                        action: { viewModel.sendCommand(.volumeUp) }
                    )
                }
                .transition(.opacity.combined(with: .scale)) // ⬅️ 버튼들도 자연스럽게 등장
                .animation(.easeInOut(duration: 0.4), value: viewModel.isPlaying)
            }
        }

        
        // 중앙: MP3 제어 버튼
        HStack(spacing: 60) {
            Button(action: { viewModel.sendCommand(.previous) }) {
                Image(systemName: MP3ViewModel.MP3Command.previous.systemImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Button(action: {
                withAnimation { // ✅ 뷰 전환 애니메이션
                        viewModel.sendCommand(viewModel.isPlaying ? .stop : .play)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    Image(systemName: viewModel.isPlaying ? MP3ViewModel.MP3Command.stop.systemImage : MP3ViewModel.MP3Command.play.systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                }
            }
            
            Button(action: { viewModel.sendCommand(.next) }) {
                Image(systemName: MP3ViewModel.MP3Command.next.systemImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
        }
        .padding(.bottom,20)
    }
}


@ViewBuilder
func volumeButton(image: String, label: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        VStack(spacing: 6) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .shadow(color: .cyan.opacity(0.4), radius: 8, x: 0, y: 4)
                )
                .foregroundColor(.white)

            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
        }
    }
    .buttonStyle(PlainButtonStyle())
}

