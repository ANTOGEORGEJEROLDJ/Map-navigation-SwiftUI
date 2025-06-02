//
//  HomePage.swift
//  MapKit SwiftUI
//
//  Created by Paranjothi iOS MacBook Pro on 02/06/25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: ContentView()){
                    Text("map")
                        .padding()
                        .font(.title)
                        .background(Color.red.opacity(6))
                        .foregroundColor(.white)
                        .bold()
                        .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
