//
//  vStateUI.swift
//  vStatus
//
//  Created by yuhei yamauchi on 2020/06/27.
//

import SwiftUI

struct vStateUI: View {

    let url: String
    @ObservedObject private var VStateApi = VStateApi()

    init(url: String) {
        self.url = url
        self.VStateApi.getData(url: self.url)
    }

    var body: some View {
        if let js = self.VStateApi.getData {
            let img = UIImage(data: js)
            return VStack {
                Image(uiImage: img!).resizable()
            }
        } else {
            return VStack {
                Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!).resizable()
            }
        }
    }
}
