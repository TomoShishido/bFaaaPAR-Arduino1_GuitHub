//
//  ContentView.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/03/21.
//  Copyright © 2020 宍戸知行. All rights reserved.
//

import SwiftUI
import ARKit

struct ContentView: View {
    
    var navigator = PDFViewNavigator()
    //@State変数で規定するBluetooth制御 (Bluetooth manager)
    @State var managerForBLE: BLEManager!
    
    //ARKitでの制御用変数
    //Button State
    @State private var ARKitFlag = false
    @State private var angleDetection:ARKitAngleDetection!
    @State private var leftY: Float = 0.0
   //
    //@State var canvasAngleDetection: ARKitForCanvas!
    //ARKitがsupportされていない時のAlertFlag
    @State private var showingARNotSupportedAlert = false
    
    
    
    //サンプルPDFファイル
    let urlString = "https://bfaaap.com/pdflink/Pathetique.pdf"
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.631372549, green: 0.6352941176, blue: 0.662745098, alpha: 1))
            VStack(alignment: .center) {
                Spacer()
                
                PDFView(url: URL(string: self.urlString)!, navigator: self.navigator)
                
                HStack{
                    if ARKitFlag {
                     //   print("頭の傾き角度：\(Int(self.angleDetection.leftY))")
                    Text("Head's angle：\(Int(self.leftY))")
                        .font(.title)
                    }
                }
                .padding()
               
                HStack(spacing: 12){
                    
                    Button(action: {
                        self.navigator.goToPreviousPage()
                        _ = self.managerForBLE.sendString(sendText: "RED")
                        
                    }){
                        Text(verbatim: NSLocalizedString("Back", comment: "前へ"))
                            .fontWeight(.bold)
                            .font(.title)
                            .lineLimit(0)
                            
                            .foregroundColor(.black)
                            //.frame(width: (geometry.size.width - self.spacing * 3) / 2)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5)
                        )
                    }
                    Spacer()
                    
                    //ARkitで制御するためのbutton
                    Button(action: {
                        self.ARKitFlag.toggle()
                        if self.ARKitFlag {
                            //cameraの機能チェック
                            guard ARFaceTrackingConfiguration.isSupported else {
                                self.ARKitFlag = false
                                self.showingARNotSupportedAlert = true
                                return }
                            //ARSupported
                            self.showingARNotSupportedAlert = false
                            
                            
                            self.angleDetection.resetTracking()
                            
                            
                        } else {
                            print("ARkitFlag becomes false")
                            
                            self.angleDetection.stopTracking()
                            
                            
                        }
                        
                        
                    } ){
                        if self.ARKitFlag {
                            Text("AR OFF")
                                .font(.title)
                                .foregroundColor(.red)
                                .background(Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 5))
                        } else {
                            Text("AR ON")
                                .font(.title)
                                .foregroundColor(.black)
                                .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 5))
                        }
                    }
                    .alert(isPresented: self.$showingARNotSupportedAlert) {
                        Alert(title: Text(verbatim: NSLocalizedString("   AR not supported.    ", comment: "AR使用できません")), message: Text(verbatim: NSLocalizedString("  This device has no in-depth camera.    ", comment: "本デバイスにはin-depthカメラが搭載されていません")), dismissButton: .default(Text(verbatim: NSLocalizedString("  OK  ", comment: "OK"))))
                    }
                    
                    
                    Spacer()
                    
                    
                    
                    Button(action: {
                        self.navigator.goToNextPage()
                        _ = self.managerForBLE.sendString(sendText: "BLUE")
                        
                    }){
                        Text(verbatim: NSLocalizedString("Next", comment: "次へ"))
                            .fontWeight(.bold)
                            .font(.title)
                            .lineLimit(0)
                            
                            .foregroundColor(.black)
                            // .frame(width: (geometry.size.width - self.spacing * 3) / 2)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5)
                        )
                    }
                    
                    
                    
                    
                }//HStackの最後の}
                
                
                
            }//VStackの最後の}
        }//ZStackの最後の}
           // .navigationBarTitle("", displayMode: .inline)
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 1)
            .padding(.bottom, 5)
            //.padding(.leading, 60)
            //.padding(.trailing, 60)
            .onAppear{
                //UserDefaultsの値の読み込み
                if let tempoffset = UserDefaults.standard.object(forKey: "offset")  {
                    globalOffset = tempoffset as! Int
                    
                }
                if let tempmultiplier = UserDefaults.standard.object(forKey: "multiplier")  {
                    globalMultiplier = tempmultiplier as! Int
                    
                }
                //bluetooth開始とARもセットする。
                self.managerSettingUp()
                
        }//onAppearの最後の}
            .onDisappear{
                //画面が変わるとARKitのセッションをoffにしてbluetoothを止める
                self.angleDetection.stopTracking()
                self.ARKitFlag = false
                
                self.managerForBLE.disconnect()
                
                
                
        }
    }
    
     func managerSettingUp() {
        
        self.managerForBLE = BLEManager(navigator: self.navigator)
        print("viewController のinstance作成")
        self.managerForBLE.setup()
        
        //ARKitの準備
        self.angleDetection = ARKitAngleDetection(navigator: self.navigator, managerForBLE: self.managerForBLE, leftY: self.$leftY)
        
        //ARKitをoffにする
        self.ARKitFlag = false
        self.angleDetection.stopTracking()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
