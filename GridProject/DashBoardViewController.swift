//
//  ContentView.swift
//  GridProject
//
//  Created by macbook on 6/8/23.
//

import SwiftUI
struct DashBoardViewController: View {
    
    var body: some View {
        NavigationView {
            TabView{
                FavoritesViewController()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Favorites")
                    }
                ListViewController()
                    .tabItem {
                        Image(systemName: "globe")
                        Text("Icon")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardViewController()
    }
}
