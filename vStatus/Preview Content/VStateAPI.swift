//
//  VStateAPI.swift
//  vStatus
//
//  Created by yuhei yamauchi on 2020/06/27.
//

import SwiftUI
import Alamofire

class StreamEventModel: Decodable {
    var future: [Event]

    struct Event: Decodable {
        var streamerName: String
        var streamerIconUrl: String
        var streamerColor: String
        var org: String

        var streamUrl: String
        var title: String
        var thumbnail: String
        var startTime: String
        var endTime: String
        var isNowStream: Bool
    }
}

class VStateAPI {
    
    var schedules: StreamEventModel?
    
    func getStreamEvent(mode: String) {
        // modeがおかしいから強制終了
        if ["past", "now", "future"].contains(mode) == false {
            return
        }
        let apiUrl = "https://x0y14-devs.el.r.appspot.com/api/schedule/\(mode)"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(apiUrl, method: .get, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in
            guard let data = response.data else {
                return
            }
            do {
                print(data)
                self.schedules = try JSONDecoder().decode(StreamEventModel.self, from: data)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
