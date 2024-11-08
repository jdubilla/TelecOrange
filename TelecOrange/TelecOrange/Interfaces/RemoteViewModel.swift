//
//  RemoteViewModel.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import SwiftUI

// MARK: - Enum for Keys
enum RemoteKey: String {
    case arrowDown = "108"
    case arrowLeft = "105"
    case arrowRight = "106"
    case arrowUp = "103"
    case channelDown = "403"
    case channelUp = "402"
    case home = "139"
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
    case ok = "352"
    case power = "116"
    case volumeDown = "114"
    case volumeUp = "115"
}

class RemoteViewModel: ObservableObject {
    @Published var showToast = false
    
    func sendTVCommand(key: RemoteKey) {
        guard let url = URL(string: "http://192.168.1.21:8080/remoteControl/cmd?operation=01&key=\(key)&mode=0") else {
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
}
