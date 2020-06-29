//
//  ContentView.swift
//  vStatus
//
//  Created by yuhei yamauchi on 2020/06/27.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation


struct ContentView: View {
    @ObservedObject var getNowStream = JSScheduleData(mode_: "now", count: -1)
    @ObservedObject var getFutureStream = JSScheduleData(mode_: "future", count: -1)
    
    var body: some View{
        NavigationView {
            List(getNowStream.StreamSchedule + getFutureStream.StreamSchedule) {live in
                NavigationLink(destination: MoreDetailView(ev: live))
                {
                    ListRow(
                        streamerName: live.streamerName, streamerIconUrl: live.streamerIconUrl,
                        streamerColor: live.streamerColor, streamUrl: live.streamUrl,
                        title: live.title, thumbnail: live.thumbnail,
                        startTime: live.startTime, endTime: live.endTime,
                        isNowStream: live.isNowStream, org: live.org, embed: live.embed)
                }
            }.navigationTitle(Text("配信スケジュール"))
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
