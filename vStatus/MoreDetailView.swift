//
//  MoreDetailView.swift
//  vStatus
//
//  Created by yuhei yamauchi on 2020/06/28.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit
import AVFoundation
import UIKit
import WebKit


struct MoreDetailView: View {
//    @property(nonatomic, strong) IBOutlet WKYTPlayerView *playerView;
    var ev: StreamEventType

    var body: some View {
        VStack {
//            AnimatedImage(url: URL(string: ev.thumbnail)).aspectRatio(contentMode: .fit)
            AnimatedImage(url: URL(string: ev.streamerIconUrl)).resizable().frame(width: 100, height: 100).clipShape(Circle()).overlay(Circle().stroke(Color(hex: ev.streamerColor), lineWidth: 2))
            HStack{
                Text(ev.streamerName).font(.title)
                Text("(\(ev.org))").font(.subheadline)
            }
            Text(ev.title).font(.subheadline)
            Button(action: {
                UIApplication.shared.open(URL(string: ev.streamUrl)!)
            }, label: {Text("配信を見に行く")})
            WebView(url: ev.embed).frame(width: 300, height: 150)
        }.offset(y: -100)
    }
}

struct MoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailView(ev: [StreamEventType]()[0])
    }
}
