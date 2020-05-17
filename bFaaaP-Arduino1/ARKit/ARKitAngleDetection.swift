//
//  ARKitAngleDetection.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/03/30.
//  Copyright © 2020 宍戸知行. All rights reserved.
//

import ARKit
import Combine
import SwiftUI

 final class ARKitAngleDetection: NSObject, ObservableObject, ARSessionDelegate {
    //PDFViewを使用するため
    unowned var navigator: PDFViewNavigator
     
    //BLE通信のため
    //@State変数で規定するBluetooth制御
    var managerForBLE: BLEManager!
   

    init(navigator: PDFViewNavigator, managerForBLE: BLEManager, leftY: Binding<Float>) {
        self.navigator = navigator
        self.managerForBLE = managerForBLE
        _leftY = leftY
        
    }
    //共通データ（角度の域値）
   // @EnvironmentObject private var userData: UserData
    
    
    
    // ARSession
    let session = ARSession()

    //Left Eye Angle Data
    @Published var leftX:Float = 0.0
    @Binding var leftY: Float
    //ある幅以上に変わった場合にBLE通信するための前回設定値とその幅
    var previousLeftY: Float = 0.0
    let margineForLeftY:Float = 1.0
    
    //PageAction
   // var angleThreshold: Float =  5.0 UserDataでpublicに指定
    @Published var pageAction = PageAction.neutral


    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        //delegate設定
        self.session.delegate = self
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func stopTracking() {
        
        self.session.pause()
        
        
        
    }
    
    

    //MARK:- ARSessionDelegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frame.anchors.forEach { anchor in
            guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor else { return }

            
           
                //Y方向の動き
                let leftYRadian = faceAnchor.transform.columns.2.y //顔の角度だけにする目の角度は入れない+ faceAnchor.leftEyeTransform.columns.2.y
                self.leftY = leftYRadian.radiansToDegrees
            //ある幅以上変化した時だけBLE送信する
            if self.leftY < (self.previousLeftY - self.margineForLeftY) || self.leftY > (self.previousLeftY + self.margineForLeftY) {
            self.previousLeftY = self.leftY
                print("変化したleftYの値は：\(-Int(self.leftY))")
              //offsetとmultiplyerを考慮に入れて、bFaaaPArduinoにおくる値(0<a<47)を作成する
                var calculatedAngleValue = (-Int(self.leftY) - globalOffset) * globalMultiplier
                if calculatedAngleValue < 0 { calculatedAngleValue = 0}
                if calculatedAngleValue > 47 { calculatedAngleValue = 47}
                
                _ = self.managerForBLE.sendString(sendText: "a\(calculatedAngleValue)")
                print("bFaaaPに送るcalculatedAngleValueは：\(calculatedAngleValue)")
            }
                
           
            
            // FaceAnchor
            //let left = faceAnchor.leftEyeTransform
            //X方向の動き
            let leftXRadian = faceAnchor.transform.columns.2.x // 顔の角度だけにする目の角度は入れない+ faceAnchor.leftEyeTransform.columns.2.x
            self.leftX = leftXRadian.radiansToDegrees
            
            //PDFのPage操作とCanvasViewの操作
            if self.pageAction == PageAction.back {
              //状態がbackの場合の処理
                if self.leftX < -angleThreshold {
                    self.pageAction = PageAction.back
                } else if self.leftX < angleThreshold {
                    self.pageAction = PageAction.neutral
                } else {
                    self.pageAction = PageAction.next
                    self.navigator.goToNextPage()
                     _ = self.managerForBLE.sendString(sendText: "BLUE")
                }
                
                
            } else if self.pageAction == PageAction.neutral {
               //状態がneutralの場合の処理
                if self.leftX < -angleThreshold {
                    self.pageAction = PageAction.back
                    self.navigator.goToPreviousPage()
                    _ = self.managerForBLE.sendString(sendText: "RED")
                    
                } else if self.leftX < angleThreshold {
                    self.pageAction = PageAction.neutral
                } else {
                    self.pageAction = PageAction.next
                    self.navigator.goToNextPage()
                    _ = self.managerForBLE.sendString(sendText: "BLUE")
                }
                
                
            } else {
                //状態がnextの場合の処理
                if self.leftX < -angleThreshold {
                    self.pageAction = PageAction.back
                    self.navigator.goToPreviousPage()
                   _ = self.managerForBLE.sendString(sendText: "RED")
                    
                } else if self.leftX < angleThreshold {
                    self.pageAction = PageAction.neutral
                } else {
                    self.pageAction = PageAction.next
                    
                }
                
            }//elseの最後の}
            
       
          
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {}





}



extension FloatingPoint {
    
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
    
}

enum PageAction {
    case back
    case neutral
    case next
    
}

//AngleDetectionの角度域値
public var angleThreshold:Float = 5.0

//Globalなoffsetとmultiplierの
public var globalOffset = 10
public var globalMultiplier = 5
