//
//  SupportPageView.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/03/30.
//  Copyright © 2020 宍戸知行. All rights reserved.
//

import SwiftUI

struct SupportPageView: View {
    
    //各国の言葉で振り分けるため (to select the language)
    let prefLang = Locale.preferredLanguages.first
    
    var body: some View {
        UINavigationBar.appearance().tintColor = UIColor.blue
        return NavigationView {
            
            ZStack{
                Color(#colorLiteral(red: 0.631372549, green: 0.6352941176, blue: 0.662745098, alpha: 1))
                VStack(alignment: .center) {
                    
                    
                    Spacer()
                    
                    if (prefLang?.hasPrefix("en"))!{
                        //英語の時の処理 (English)
                        
                        
                        NavigationLink(
                            destination: WebView(webURLString: "https://bfaaap.com/wpe/bfaaap-pager-support/")
                            )
                        {
                            Text(verbatim: NSLocalizedString("Technical Support", comment: "技術サポート"))
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 5)
                            )
                        }
                    }else if (prefLang?.hasPrefix("ja"))!{
                        
                        //日本語の時の処理(Japanese)
                        NavigationLink(
                            destination: WebView(webURLString: "https://bfaaap.com/bfaaap-pagerサポートサイト/")
                            )
                        {
                            Text(verbatim: NSLocalizedString("Technical Support", comment: "技術サポート"))
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 5)
                            )
                        }
                    } else if (prefLang?.hasPrefix("de"))!{
                        //ドイツ語の時の処理 (Deutsch)
                        NavigationLink(
                            destination: WebView(webURLString: "https://bfaaap.com/wpd/bfaaap-pager-kundenservice/")
                            )
                        {
                            Text(verbatim: NSLocalizedString("Technical Support", comment: "技術サポート"))
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 5)
                            )
                        }
                        
                    } else {
                        //他言語の時は英語 (English)
                        NavigationLink(
                            destination: WebView(webURLString: "https://bfaaap.com/wpe/bfaaap-pager-support/")
                            )
                        {
                            Text(verbatim: NSLocalizedString("Technical Support", comment: "技術サポート"))
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 5)
                            )
                        }
                    }
                    NavigationLink(
                        destination: WebView(webURLString: "https://bfaaap.com/wpe/bfaaap-pager-support/")
                        )
                    {
                        InNavigationImage(displayItemName: "bFaaaPPager")
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                }
                .navigationBarTitle(Text(verbatim: NSLocalizedString("Support Information", comment: "サポート情報")), displayMode: .inline)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct InNavigationImage: View {
    var displayItemName: String
    var body: some View {
        VStack(alignment: .center) {
            Image(displayItemName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                //.clipShape(Circle())
                //.overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
        }
        .padding(.leading, 15)
    }
}

struct SupportPageView_Previews: PreviewProvider {
    static var previews: some View {
        SupportPageView()
    }
}
