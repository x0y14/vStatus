//
//  VStateAPI.swift
//  vStatus
//
//  Created by yuhei yamauchi on 2020/06/28.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import Foundation
//import YouTubePlayer

class JSScheduleData: ObservableObject {
    @Published var StreamSchedule = [StreamEventType]()
    
    init(mode_: String, count: Int) {
        var mode: String
        if ["past", "now", "future", "all"].contains(mode_) {
            mode = mode_
        } else { mode = "now" }
        
        var url_ = "https://vstate-x0y14-dev.cf/api/schedule/\(mode)"
        if count != -1 {
            url_ += "?count=\(count)"
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url_)!) { (data, res, _) in
            do {
                let fetch = try JSONDecoder().decode([StreamEventType].self, from: data!)
                DispatchQueue.main.async {
                    self.StreamSchedule = fetch
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}

struct StreamEventType: Identifiable, Decodable {
    var id: Int
    var streamerName: String
    var streamerIconUrl: String
    var streamerColor: String

    var streamUrl: String
    var title: String
    var thumbnail: String
    var startTime: String
    var endTime: String
    var isNowStream: Bool
    var org: String
    var embed: String

}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

class Other {
    static func getDateFromISO(start: String, end: String) -> String {
        let calendar = Calendar.current
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        
        let startDate:Date = formatter.date(from: start) ?? Date()
        let endDate:Date = formatter.date(from: end) ?? Date()
        
        let shour_ = calendar.component(.hour, from: startDate)
        let sminute_ = calendar.component(.minute, from: startDate)
        
        let ehour_ = calendar.component(.hour, from: endDate)
        let eminute_ = calendar.component(.minute, from: endDate)
        
        var shour: String
        var sminute: String
        
        var ehour: String
        var eminute: String
        
        // ゼロ埋めの儀
        if ([0,1,2,3,4,5,6,7,8,9].contains(shour_)) {
            shour = "0\(shour_)"
        } else {shour = "\(shour_)"}
        
        if ([0,1,2,3,4,5,6,7,8,9].contains(sminute_)) {
            // 一桁
            sminute = "0\(sminute_)"
        } else {sminute = "\(sminute_)"}
        
        if ([0,1,2,3,4,5,6,7,8,9].contains(ehour_)) {
            // 一桁
            ehour = "0\(ehour_)"
        } else {ehour = "\(ehour_)"}
        
        if ([0,1,2,3,4,5,6,7,8,9].contains(eminute_)) {
            // 一桁
            eminute = "0\(eminute_)"
        } else {eminute = "\(eminute_)"}
        
        return "\(shour):\(sminute) ~ \(ehour):\(eminute)"
    }
}

struct ListRow: View {
    var streamerName: String
    var streamerIconUrl: String
    var streamerColor: String

    var streamUrl: String
    var title: String
    var thumbnail: String
    var startTime: String
    var endTime: String
    var isNowStream: Bool
    var org: String
    var embed: String
    
//    let formatter = ISO8601DateFormatter()
//    formatter.date(from: "2018-09-18T02:00:00Z")
//    var startDate = formatter.date(from: startTime)
//    var endDate = formatter.date(from: endTime)
    
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: streamerIconUrl)).resizable().frame(width: 60, height: 60).clipShape(Circle()).overlay(Circle().stroke(Color(hex: streamerColor), lineWidth: 2))
            VStack(alignment: .leading) {
                HStack {
                    Text(streamerName).fontWeight(.heavy)
                    if (isNowStream) {Text("Live")
                        .font(.subheadline)
                        .foregroundColor(Color.red)
                        .padding(3.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1.5)
                        )}
                }
                Text(Other.getDateFromISO(start: startTime, end: endTime)).font(.subheadline)
            }
            Spacer()
            Spacer()
        }
    }
}
