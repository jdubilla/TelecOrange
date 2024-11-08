//
//  NetworkHelper.swift
//  TelecOrange
//
//  Created by Jean-baptiste DUBILLARD on 08/11/2024.
//

import Foundation
import Network

class NetworkHelper {
    static func checkAllIPs() {
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
    
    private static func checkConnectionToIP(ip: String, port: UInt16, completion: @escaping (String?) -> Void) {
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
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            connection.cancel()
        }
    }
}
