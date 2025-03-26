import SwiftUI


struct MainView: View {
    @StateObject private var scanVM = ScanViewModel()
    @StateObject private var mainVM = MainViewModel()
    let weatherViewModel = WeatherViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // 상단 텍스트
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Connected Car")
                                .font(.headline)
                                .foregroundColor(.white)
                                .scaleEffect(mainVM.isDeviceConnected ? 1.1 : 1.0)
                                .opacity(mainVM.isDeviceConnected ? 1 : 0.8)
                                .animation(.easeInOut(duration: 0.5), value: mainVM.isDeviceConnected)

                            Text("Controller")
                                .font(.title)
                                .foregroundColor(.white)
                                .scaleEffect(mainVM.isDeviceConnected ? 1.1 : 1.0)
                                .opacity(mainVM.isDeviceConnected ? 1 : 0.8)
                                .animation(.easeInOut(duration: 0.5).delay(0.1), value: mainVM.isDeviceConnected)
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }

                    // 이미지
                    Group {
                        if mainVM.isDeviceConnected {
                            Image("Gen")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 160)
                        } else {
                            Image(systemName: "car.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 160)
                                .foregroundColor(.white)
                        }
                    }

                    // 토글
                    Toggle(isOn: $mainVM.isBluetoothOn) {
                        Text("차량 검색")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .cyan))
                    .onChange(of: mainVM.isBluetoothOn) {
                        withAnimation {
                            mainVM.toggleBluetooth(mainVM.isBluetoothOn)
                        }
                    }
                    .padding(.horizontal, 40)

                    // 기기 목록
                    if mainVM.isBluetoothOn && !mainVM.isDeviceConnected && !mainVM.isConnecting {
                        VStack {
                            Text("기기 목록")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            List(scanVM.devices) { device in
                                Button {
                                    mainVM.selectedDevice = device
                                    mainVM.showConnectAlert = true
                                } label: {
                                    HStack {
                                        Image(systemName: "cpu")
                                        Text(device.name)
                                            .foregroundColor(.white)
                                    }
                                }
                                .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                            .frame(height: 200)
                        }
                    }

                    // 연결 중 로딩
                    if mainVM.isBluetoothOn && mainVM.isConnecting {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("연결 중...")
                                .foregroundColor(.white)
                        }
                    }

                    // 연결 완료 시 RemoteControlPanel 표시
                    if mainVM.isBluetoothOn && mainVM.isDeviceConnected {
                        RemoteControlPanel(weatherViewModel: weatherViewModel)
                            .frame(maxWidth:.infinity ,maxHeight: .infinity)
                    }

                    Spacer()
                }
                .alert(isPresented: $mainVM.showConnectAlert) {
                    Alert(
                        title: Text("기기 연결"),
                        message: Text("정말 이 기기에 연결하시겠습니까?"),
                        primaryButton: .default(Text("확인"), action: {
                            mainVM.connectToDevice()
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .onAppear{
            weatherViewModel.fetchWeather()
        }
    }
}

