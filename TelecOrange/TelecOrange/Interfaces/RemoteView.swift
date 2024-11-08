//
//  RemoteView.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

struct RemoteView: View {
    
    @StateObject private var vm = RemoteViewModel()
    
    var body: some View {
        ScrollView {
            HomeAndPowerView()
            
            ChannelVolueAndControlPadView()
            
            GridNumbersView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(.grayLight)
        .onAppear {
            checkAllIPs()
        }
        .onChange(of: vm.showToast) { newValue in
            guard newValue else { return }
            vm.showErrorToast()
        }
        .overlay(
            ToastView()
                .padding(.top, 20),
            alignment: .top
        )
    }
}

import Network

// Fonction pour tester la connexion à une IP donnée sur le port 8080
func checkConnectionToIP(ip: String, port: UInt16, completion: @escaping (String?) -> Void) {
    let host = NWEndpoint.Host(ip)
    let port = NWEndpoint.Port(rawValue: port)!
    let connection = NWConnection(host: host, port: port, using: .tcp)
    
    connection.stateUpdateHandler = { state in
        switch state {
        case .ready:
            print("\(ip) is reachable on port \(port).")
            completion(ip)
        case .failed(_):
            completion(nil)
        default:
            break
        }
    }
    
    connection.start(queue: .global())
    
    // Timeout pour la connexion
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        connection.cancel()
    }
}

// Fonction pour tester toutes les adresses IP de 192.168.1.1 à 192.168.1.255
func checkAllIPs() {
    var reachableIPs: [String] = []
    
    let group = DispatchGroup()
    
    for i in 1...255 {
        let ip = "192.168.1.\(i)"
        
        group.enter()
        checkConnectionToIP(ip: ip, port: 8080) { result in
            if let ip = result {
                reachableIPs.append(ip)
            }
            group.leave()
        }
    }
    
    group.notify(queue: .main) {
        print("Reachable IPs on port 8080:")
        reachableIPs.forEach { print($0) }
    }
}

#Preview {
    RemoteView()
}

extension RemoteView {
    
    // MARK: HomeAndPowerView
    @ViewBuilder
    private func HomeAndPowerView() -> some View {
        VStack(spacing: 8) {
            Image(systemName: "tv")
            
            HStack(spacing: 0) {
                ImageButtonView(
                    image: "house.fill",
                    colorImage: .white,
                    key: .home
                )
                
                Spacer()
                
                ImageButtonView(
                    image: "power",
                    colorImage: .red,
                    key: .power
                )
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: ChannelVolueAndControlPadView
    @ViewBuilder
    private func ChannelVolueAndControlPadView() -> some View {
        HStack(spacing: 0) {
            CapsuleButtonsView(
                firstImageName: "plus",
                firstKey: .volumeUp,
                buttonName: "Vol",
                secondImageName: "minus",
                secondKey: .volumeDown
            )
            
            Spacer()
            
            ControlPadView()
            
            Spacer()
            
            CapsuleButtonsView(
                firstImageName: "plus",
                firstKey: .channelUp,
                buttonName: "Ch",
                secondImageName: "minus",
                secondKey: .channelDown
            )
        }
        .padding(.top, 8)
    }
    
    // MARK: ControlPadView
    @ViewBuilder
    private func ControlPadView() -> some View {
        ZStack {
            Circle()
                .frame(width: 190, height: 190)
                .customShadowStyle()
            
            ForEach(0..<11, id: \ .self) { path in
                let circleSize = 170 - 15 * CGFloat(path)
                
                Circle()
                    .stroke(.gray.opacity(0.1), lineWidth: 3)
                    .frame(width: circleSize, height: circleSize)
            }
            
            VStack {
                ButtonControlPadView(imageName: "chevron.up", key: .arrowUp)
                
                Spacer()
                
                HStack {
                    ButtonControlPadView(imageName: "chevron.left", key: .arrowLeft)
                    
                    Spacer()
                    
                    Button("Ok") {
                        vm.generateTapticFeedback()
                        vm.sendTVCommand(key: .ok)
                    }
                    .font(.system(size: 25))
                    .foregroundStyle(.white)
                    .opacity(0.85)
                    
                    Spacer()
                    
                    ButtonControlPadView(imageName: "chevron.right", key: .arrowRight)
                }
                
                Spacer()
                
                ButtonControlPadView(imageName: "chevron.down", key: .arrowDown)
            }
            .padding(8)
        }
        .frame(width: 190, height: 190)
    }
    
    // MARK: ButtonControlPadView
    @ViewBuilder
    private func ButtonControlPadView(imageName: String, key: RemoteKey) -> some View {
        Button {
            vm.generateTapticFeedback()
            vm.sendTVCommand(key: key)
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundStyle(.white.opacity(0.85))
        }
    }
    
    // MARK: GridNumbersView
    @ViewBuilder
    private func GridNumbersView() -> some View {
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        LazyVGrid(columns: columns, spacing: 16) {
            TextButtonView(text: "1", key: .number1)
            TextButtonView(text: "2", key: .number2)
            TextButtonView(text: "3", key: .number3)
            
            TextButtonView(text: "4", key: .number4)
            TextButtonView(text: "5", key: .number5)
            TextButtonView(text: "6", key: .number6)
            
            TextButtonView(text: "7", key: .number7)
            TextButtonView(text: "8", key: .number8)
            TextButtonView(text: "9", key: .number9)
            
            GridRow {
                Spacer()
                
                TextButtonView(text: "0", key: .number0)
                
                Spacer()
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: TextButtonView
    @ViewBuilder
    private func TextButtonView(text: String, key: RemoteKey) -> some View {
        Circle()
            .frame(width: 80, height: 80)
            .customShadowStyle()
            .overlay {
                Button {
                    vm.generateTapticFeedback()
                    vm.sendTVCommand(key: key)
                } label: {
                    Text(text)
                        .foregroundStyle(.white.opacity(0.85))
                        .font(.system(size: 25))
                        .frame(width: 80, height: 80)
                }
            }
    }
    
    // MARK: ImageButtonView
    @ViewBuilder
    private func ImageButtonView(
        image: String,
        colorImage: Color,
        key: RemoteKey
    ) -> some View {
        Circle()
            .frame(width: 80, height: 80)
            .customShadowStyle()
            .overlay {
                Button {
                    vm.generateTapticFeedback()
                    vm.sendTVCommand(key: key)
                } label: {
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(colorImage.opacity(0.85))
                }
            }
    }
    
    // MARK: CapsuleButtonsView
    @ViewBuilder
    private func CapsuleButtonsView(
        firstImageName: String,
        firstKey: RemoteKey,
        buttonName: String,
        secondImageName: String,
        secondKey: RemoteKey
    ) -> some View {
        RoundedRectangle(cornerRadius: 50)
            .frame(width: 70, height: 180)
            .customShadowStyle()
            .overlay {
                VStack(spacing: 32) {
                    Button {
                        vm.generateTapticFeedback()
                        vm.sendTVCommand(key: firstKey)
                    } label: {
                        Image(systemName: firstImageName)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    
                    Text(buttonName)
                        .foregroundStyle(.white.opacity(0.85))
                    
                    Button {
                        vm.generateTapticFeedback()
                        vm.sendTVCommand(key: secondKey)
                    } label: {
                        Image(systemName: secondImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            }
    }
    
    // MARK: ToastView
    @ViewBuilder
    private func ToastView() -> some View {
        VStack {
            Text("Une erreur est survenue")
                .padding()
                .background(Color.red)
                .cornerRadius(8)
                .offset(y: vm.showToast ? 0 : -150)
                .animation(.easeInOut, value: vm.showToast)
                .onTapGesture {
                    vm.showToast = false
                }
        }
    }
}
