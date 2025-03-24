import SwiftUI

struct MainView: View {
    @StateObject private var scanVM = ScanViewModel()
    @StateObject private var connectionVM = ConnectionViewModel()
    @State private var isBluetoothOn = false
    @State private var selectedDevice: BLEDevice? = nil
    @State private var showConnectAlert = false
    @State private var isDeviceConnected = false
    @State private var isConnecting = false
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Connected Car")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .bold()
                                    .scaleEffect(isDeviceConnected ? 1.1 : 1.0)
                                    .opacity(isDeviceConnected ? 1 : 0.8)
                                    .animation(.easeInOut(duration: 0.5), value: isDeviceConnected)
                                Text("Controller")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .bold()
                                    .scaleEffect(isDeviceConnected ? 1.1 : 1.0)
                                    .opacity(isDeviceConnected ? 1 : 0.8)
                                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: isDeviceConnected)
                            }
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    Group {
                        if isDeviceConnected {
                            Image("Gen")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 160)
                                .padding(.horizontal)
                                .transition(.opacity.combined(with: .scale))
                        } else {
                            Image(systemName: "car.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 160)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    
                    Toggle(isOn: $isBluetoothOn) {
                        Text("차량 검색")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.cyan))
                    .onChange(of: isBluetoothOn) {
                        withAnimation {
                            if isBluetoothOn {
                                scanVM.startScan()
                            } else {
                                scanVM.stopScan()
                                connectionVM.disconnect()
                                isDeviceConnected = false
                                isConnecting = false
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    if isBluetoothOn && !isDeviceConnected && !isConnecting {
                        VStack {
                            Text("기기 목록")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            List(scanVM.devices) { device in
                                Button(action: {
                                    selectedDevice = device
                                    showConnectAlert = true
                                }) {
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
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    if isBluetoothOn && isConnecting {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("연결 중...")
                                .foregroundColor(.white)
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    if isBluetoothOn && isDeviceConnected {
                        RemoteControlPanel()
                            .frame(maxWidth:.infinity ,maxHeight: .infinity)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    
                    Spacer()
                }
                //.padding()
                .alert(isPresented: $showConnectAlert) {
                    Alert(
                        title: Text("기기 연결"),
                        message: Text("정말 이 기기에 연결하시겠습니까?"),
                        primaryButton: .default(Text("확인"), action: {
                            if let device = selectedDevice {
                                isConnecting = true
                                scanVM.connect(to: device)
                                
                                let startTime = Date()
                                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                    let elapsed = Date().timeIntervalSince(startTime)
                                    if connectionVM.isConnected && elapsed >= 1.0 {
                                        timer.invalidate()
                                        withAnimation {
                                            isDeviceConnected = true
                                            isConnecting = false
                                        }
                                    } else if elapsed >= 5.0 { // 최대 대기 시간 초과
                                        timer.invalidate()
                                        withAnimation {
                                            isConnecting = false
                                        }
                                    }
                                }
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}




