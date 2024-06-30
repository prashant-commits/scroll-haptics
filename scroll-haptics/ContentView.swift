//
//  ContentView.swift
//  scroll-haptics
//
//  Created by Prashant Garg on 27/06/24.
//

import SwiftUI
import Cocoa

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Sign In", systemImage: "arrow.up") {() -> Void in
                print(0)
                
            }

        }
        .padding()
        .frame(width: 300, height: 300)
        
    }
}

#Preview {
    ContentView()
}
