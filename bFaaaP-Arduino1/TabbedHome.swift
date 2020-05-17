//
//  TabbedHome.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/03/30.
//  Copyright © 2020 宍戸知行. All rights reserved.
//

import SwiftUI

struct TabbedHome: View {
    
    
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
    }
    
    var body: some View {
        TabView {
            
            
            ContentView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text(verbatim: NSLocalizedString("List", comment: "リスト"))
                    
            }.tag(1)
            
            
            
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text(verbatim: NSLocalizedString("Setting", comment: "設定"))
            }.tag(2)
            
           
            
            SupportPageView()
                .tabItem {
                    Image(systemName: "person")
                    Text(verbatim: NSLocalizedString("Support", comment: "サポート"))
            }.tag(3)
            
            
        }
        .accentColor(Color(red: 255/255, green: 233/255, blue: 51/255, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
        
        
        
    }
}

struct TabbedHome_Previews: PreviewProvider {
    static var previews: some View {
        TabbedHome()
        
    }
}
