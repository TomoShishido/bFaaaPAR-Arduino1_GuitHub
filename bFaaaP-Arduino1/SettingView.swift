//
//  SettingView.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/03/30.
//  Copyright © 2020 宍戸知行. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    //BLE用にnavigatorを作成 (PDF view navigator)
     var navigator = PDFViewNavigator()
    //@State変数で規定するBluetooth制御 (Bluetooth manager)
    @State var managerForBLE: BLEManager!
    
    //bFaaaP設定値 (various bFaaaP setting values)
    @State private var offset: Int = 5
    @State private var multiplier: Int = 20
    @State private var topPedalOffset: Int = 0
    @State private var widthPedal: Int = 15
    
    
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.968627451, green: 0.7019607843, blue: 0.03921568627, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            VStack{
            VStack{
                
             Spacer()
                Text("bFaaaP設定")
                    .bold()
                    .font(.largeTitle)
                Stepper("頭の角度オフセット（°）", onIncrement: {
                    if self.offset < 40 {
                        self.offset += 1
                        print("increase the offset")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.offset, forKey: "offset")
                    }
                },  onDecrement: {
                    if self.offset > -15 {
                        self.offset -= 1
                        print("decrease the offset")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.offset, forKey: "offset")
                    }
                })
                    .frame(width: 300, height: 50, alignment: .center)
                
                HStack (alignment: .center){
                 Spacer()
                Text("設定値")
                Text(" \(self.offset)")
                    Spacer()
                    Button(action:{
                        //sending the offset value to bFaaaP
                        _ = self.managerForBLE.sendString(sendText: "o\(self.offset)")
                        _ = self.managerForBLE.sendString(sendText: "BLUE")
                    })
                    {
                     Text("設定")
                        
                        .font(.title)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.631372549, green: 0.6352941176, blue: 0.662745098, alpha: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 3))
                    }
                }
                .padding()
                
                Divider()
                
                Stepper("加速倍率", onIncrement: {
                    if self.multiplier < 98 {
                        self.multiplier += 1
                        print("increase the multiplier")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.multiplier, forKey: "multiplier")
                    }
                },  onDecrement: {
                    if self.multiplier > 2 {
                        self.multiplier -= 1
                        print("decrease the multiplier")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.multiplier, forKey: "multiplier")
                    }
                })
                    .frame(width: 300, height: 50, alignment: .center)
                
                HStack (alignment: .center){
                 Spacer()
                Text("設定値")
                Text(" \(self.multiplier)")
                    Spacer()
                    Button(action:{
                        //sending the multiplier to bFaaaP
                        _ = self.managerForBLE.sendString(sendText: "m\(self.multiplier)")
                        _ = self.managerForBLE.sendString(sendText: "YELLOW")
                    })
                    {
                     Text("設定")
                        
                        .font(.title)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.631372549, green: 0.6352941176, blue: 0.662745098, alpha: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 3))
                    }
                }
                .padding()
            }
                Divider()
                VStack{
                Stepper("ペダルトップ", onIncrement: {
                    if self.topPedalOffset < 30 {
                        self.topPedalOffset += 1
                        print("increase the topPedalOffset")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.topPedalOffset, forKey: "topPedalOffset")
                    }
                },  onDecrement: {
                    if self.topPedalOffset > 2 {
                        self.topPedalOffset -= 1
                        print("decrease the topPedalOffset")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.topPedalOffset, forKey: "topPedalOffset")
                    }
                })
                    .frame(width: 300, height: 50, alignment: .center)
                
                HStack (alignment: .center){
                 Spacer()
                Text("設定値")
                Text(" \(self.topPedalOffset)")
                    Spacer()
                    Button(action:{
                        //sending the top offset value to bFaaaP
                        _ = self.managerForBLE.sendString(sendText: "t\(self.topPedalOffset)")
                        _ = self.managerForBLE.sendString(sendText: "RED")
                    })
                    {
                     Text("設定")
                        
                        .font(.title)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.631372549, green: 0.6352941176, blue: 0.662745098, alpha: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 3))
                    }
                }
                .padding()
            
                Divider()
         
               Stepper("ペダル動作幅", onIncrement: {
                    if self.widthPedal < 30 {
                        self.widthPedal += 1
                        print("increase the widthPedal")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.widthPedal, forKey: "widthPedal")
                    }
                },  onDecrement: {
                    if self.widthPedal > 2 {
                        self.widthPedal -= 1
                        print("decrease the widthPedal")
                        //UserDefaultsに値を保存
                        UserDefaults.standard.set(self.widthPedal, forKey: "widthPedal")
                    }
                })
                    .frame(width: 300, height: 50, alignment: .center)
                
                HStack (alignment: .center){
                 Spacer()
                Text("設定値")
                Text(" \(self.widthPedal)")
                    Spacer()
                    Button(action:{
                        //sending the actuation width to bFaaaP
                        _ = self.managerForBLE.sendString(sendText: "w\(self.widthPedal)")
                        _ = self.managerForBLE.sendString(sendText: "BLUE")
                    })
                    {
                     Text("設定")
                        
                        .font(.title)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.631372549, green: 0.6352941176, blue: 0.662745098, alpha: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 3))
                    }
                }
                .padding()
                
                
                }
            }//VStack最後の}
           
        }//ZStackの最後の}
        
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 1)
            .padding(.bottom, 5)
            //.padding(.leading, 60)
            //.padding(.trailing, 60)
            .onAppear{
                //UserDefaultsの値の読み込み(read and set the stored values)
                if let tempoffset = UserDefaults.standard.object(forKey: "offset")  {
                    self.offset = tempoffset as! Int
                    globalOffset = self.offset
                }
                if let tempmultiplier = UserDefaults.standard.object(forKey: "multiplier")  {
                    self.multiplier = tempmultiplier as! Int
                    globalMultiplier = self.multiplier
                }
                if let temptopPedalOffset = UserDefaults.standard.object(forKey: "topPedalOffset")  {
                    self.topPedalOffset = temptopPedalOffset as! Int
                   
                }
                if let tempwidthPedal = UserDefaults.standard.object(forKey: "widthPedal")  {
                    self.widthPedal = tempwidthPedal as! Int
                    
                }
             //bluetooth開始とARもセットする。
                self.managerSettingUp()
                
        }//onAppearの最後の}
        .onDisappear{
        //disconnect Bluetooth manager
            self.managerForBLE.disconnect()
        }
    }
    func managerSettingUp() {
        //set up the Bluetooth manager
        self.managerForBLE = BLEManager(navigator: self.navigator)
        print("viewController のinstance作成")
        self.managerForBLE.setup()

    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
