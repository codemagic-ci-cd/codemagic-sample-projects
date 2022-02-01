//
//  ContentView.swift
//  XCRemoteCacheExample
//
//  Created by Rudrank Riyam on 27/01/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://example.com/image.png"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
