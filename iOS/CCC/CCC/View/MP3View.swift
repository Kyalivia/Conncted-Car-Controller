import SwiftUI

struct MP3View: View {
    @ObservedObject var viewModel: MP3ViewModel
    
    var body: some View {
        HStack(spacing: 40) {
            VStack {
                Button(action: { viewModel.sendCommand(.volumeUp) }) {
                    Image(systemName: "speaker.wave.3.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding()
                        .background(Color.cyan.opacity(0.2))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                Text("볼륨 +")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            Button(action: { viewModel.sendCommand(.random) }) {
                Image(systemName: MP3ViewModel.MP3Command.random.systemImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }

            VStack {
                Button(action: { viewModel.sendCommand(.volumeDown) }) {
                    Image(systemName: "speaker.wave.1.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding()
                        .background(Color.cyan.opacity(0.2))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                Text("볼륨 -")
                    .font(.caption)
                    .foregroundColor(.white)
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
                viewModel.sendCommand(viewModel.isPlaying ? .stop : .play)
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
    }
}
