//
//  RemoteViewModel.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

// MARK: - Enum for Remote Keys
enum RemoteKey: String {
    // Navigation Keys
    case arrowUp = "103"
    case arrowDown = "108"
    case arrowLeft = "105"
    case arrowRight = "106"
    case ok = "352"
    case home = "139"
    case back = "158"

    // Volume Controls
    case volumeUp = "115"
    case volumeDown = "114"
    case mute = "113"

    // Channel Controls
    case channelUp = "402"
    case channelDown = "403"

    // Number Keys
    case number0 = "512"
    case number1 = "513"
    case number2 = "514"
    case number3 = "515"
    case number4 = "516"
    case number5 = "517"
    case number6 = "518"
    case number7 = "519"
    case number8 = "520"
    case number9 = "521"

    // Playback Controls
    case playPause = "164"
    case fastForward = "159"
    case rewind = "168"
    case record = "167"

    // Power Control
    case power = "116"
}

class RemoteViewModel: ObservableObject {
    @Published var showToast = false
    @Published var showSheet = false
    @Published var showSettingsSheet = false
    @Published var selectedIps: [String] = []
    @AppStorage("boxIp") var boxIp: String = ""
    
    func sendTVCommand(key: RemoteKey) {
        guard let url = URL(string: "http://\(boxIp):8080/remoteControl/cmd?operation=01&key=\(key.rawValue)&mode=0") else {
            DispatchQueue.main.async {
                self.showToast = true
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.showToast = true
                    }
                }
            }
        }.resume()
    }
    
    func showErrorToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.showToast = false
        }
    }
    
    func generateTapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func scanIpIfNeed() {
        if boxIp.isEmpty {
            selectedIps = []
            Task { @MainActor in
                let ips = await NetworkHelper.checkAllIPs()
                if ips.count == 1, let ip = ips.first {
                    boxIp = ip
                } else if ips.count > 1 {
                    selectedIps = ips
                    showSheet = true
                }
            }
        }
    }
    
    func resetBoxIp() {
        boxIp = ""
    }
    
    func setBoxIp(ip: String) {
        boxIp = ip
    }
}
