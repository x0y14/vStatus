//
//  streamScheduler.swift
//  streamScheduler
//
//  Created by yuhei yamauchi on 2020/06/29.
//

import WidgetKit
import SwiftUI
import Intents
import SDWebImage
import SDWebImageSwiftUI


struct WidgetModel: TimelineEntry {
    var date: Date
    
    var streamEvent: [StreamEventType]
    
}


struct DataProvider: TimelineProvider {
    
    func timeline(with context: Context, completion: @escaping (Timeline<WidgetModel>) -> ()) {
        @ObservedObject let nowStream = JSScheduleData(mode_: "now", count: 3)
        @ObservedObject let futureStream = JSScheduleData(mode_: "future", count: 3)
        
        let streams = nowStream.StreamSchedule + futureStream.StreamSchedule
        print(streams)

        let entryData = WidgetModel(date: Date(), streamEvent: streams)
        
//        let nowStream_rf = JSScheduleData(mode_: "now", count: 3)
//        let futureStream_rf = JSScheduleData(mode_: "future", count: 3)
//        let streams_rf = nowStream_rf.StreamSchedule + futureStream_rf.StreamSchedule
////        let entryData_rf = WidgetModel(date: Date(), streamEvent: streams_rf)
        
        let timeline = Timeline(entries: [entryData], policy: .atEnd)
        
        completion(timeline)
    }
    
    func snapshot(with context: Context, completion: @escaping (WidgetModel) -> ()) {
//        let emptyStreamEvent = StreamEventType(
//            id: 0,
//            streamerName: "streamerName",
//            streamerIconUrl: "https://example.com",
//            streamerColor: "#f0f8ff",
//            streamUrl: "https://youtube.com",
//            title: "title",
//            thumbnail: "https://example.com",
//            startTime: "2000-06-29T00:00:00+09:00",
//            endTime: "2000-06-29T01:00:00+09:00",
//            isNowStream: false,
//            org: "example",
//            embed: "https://youtube.com"
//        )
        let nowStream = JSScheduleData(mode_: "now", count: 3)
        let futureStream = JSScheduleData(mode_: "future", count: 3)
        
        let streams = nowStream.StreamSchedule + futureStream.StreamSchedule

        let entryData = WidgetModel(date: Date(), streamEvent: streams)
        
        completion(entryData)
    }
}


struct WidgetView: View {
    
    var data: DataProvider.Entry
    
    var body: some View {
        List(data.streamEvent) { live in
            HStack {
                AnimatedImage(url: URL(string: live.streamerIconUrl)).resizable().frame(width: 60, height: 60).clipShape(Circle()).overlay(Circle().stroke(Color(hex: live.streamerColor), lineWidth: 2))
            VStack(alignment: .leading) {
                HStack {
                    Text(live.streamerName).fontWeight(.heavy)
                    if (live.isNowStream) {Text("Live")
                        .font(.subheadline)
                        .foregroundColor(Color.red)
                        .padding(3.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1.5)
                        )}
                }
                Text(Other.getDateFromISO(start: live.startTime, end: live.endTime)).font(.subheadline)
            }
            Spacer()
            Spacer()
                
            }
            
        }
    }
}



// loading中に設置されるダミー
struct PlaceHolder: View {
        
    var body: some View {
        List([StreamEventType(
            id: 0,
            streamerName: "streamerName",
            streamerIconUrl: "https://example.com",
            streamerColor: "#f0f8ff",
            streamUrl: "https://youtube.com",
            title: "title",
            thumbnail: "https://example.com",
            startTime: "2000-06-29T00:00:00+09:00",
            endTime: "2000-06-29T01:00:00+09:00",
            isNowStream: false,
            org: "example",
            embed: "https://youtube.com"
        ),StreamEventType(
            id: 0,
            streamerName: "streamerName",
            streamerIconUrl: "https://example.com",
            streamerColor: "#f0f8ff",
            streamUrl: "https://youtube.com",
            title: "title",
            thumbnail: "https://example.com",
            startTime: "2000-06-29T00:00:00+09:00",
            endTime: "2000-06-29T01:00:00+09:00",
            isNowStream: false,
            org: "example",
            embed: "https://youtube.com"
        ),StreamEventType(
            id: 0,
            streamerName: "streamerName",
            streamerIconUrl: "https://example.com",
            streamerColor: "#f0f8ff",
            streamUrl: "https://youtube.com",
            title: "title",
            thumbnail: "https://example.com",
            startTime: "2000-06-29T00:00:00+09:00",
            endTime: "2000-06-29T01:00:00+09:00",
            isNowStream: false,
            org: "example",
            embed: "https://youtube.com"
        )]) { live in
            HStack {
                AnimatedImage(url: URL(string: live.streamerIconUrl)).resizable().frame(width: 60, height: 60).clipShape(Circle()).overlay(Circle().stroke(Color(hex: live.streamerColor), lineWidth: 2))
            VStack(alignment: .leading) {
                HStack {
                    Text(live.streamerName).fontWeight(.heavy)
                    if (live.isNowStream) {Text("Live")
                        .font(.subheadline)
                        .foregroundColor(Color.red)
                        .padding(3.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1.5)
                        )}
                }
                Text(Other.getDateFromISO(start: live.startTime, end: live.endTime)).font(.subheadline)
            }
            Spacer()
            Spacer()
                
            }
            
        }
    }
}




@main
struct Config: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "StreamEventScheduler", provider: DataProvider(), placeholder: PlaceHolder()) { data in
            WidgetView(data: data)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
        .description(Text("vState Schedule Widget"))
    }
}
