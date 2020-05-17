//
//  BLEManager.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/03/21.
//  Copyright © 2020 宍戸知行. All rights reserved.
//

import UIKit
import CoreBluetooth
import PDFKit

final class BLEManager: NSObject, CBCentralManagerDelegate , CBPeripheralDelegate  {
    unowned var navigator: PDFViewNavigator
       
       init(navigator: PDFViewNavigator) {
           self.navigator = navigator
       }
  
    
   
    /// 接続先ローカルネーム
       private let connectToLocalName:String = "M5Stack-Color"
       /// CBCentralManagerインスタンス
       private var centralManager: CBCentralManager!
       /// 接続先Peripheral情報
       private var connectToPeripheral: CBPeripheral!
       /// Write Characteristic
       private var writeCharacteristic: CBCharacteristic?
       /// Notify Characteristic
       private var notifyCharacteristic: CBCharacteristic?
    
    //centralManagerの初期化
    func setup() {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            
        }
    
    //MStack側へのtext送信
    
    func sendString(sendText:String) -> Bool {
        var result = false
        if let sendData = sendText.data(using: .utf8, allowLossyConversion: true) , let characteristic = writeCharacteristic , let peripheral = connectToPeripheral {
            peripheral.writeValue(sendData, for: characteristic, type: .withResponse)
            result = true
        }
        return result
    }
    
    
    //disconnectする
    func disconnect() {
        
        if let tempconnectToPeripheral = connectToPeripheral {
        centralManager.cancelPeripheralConnection(tempconnectToPeripheral)
        }
        
    }
    
    
    
    //Delegateのprotocol関数を含める制御関数
    
    private func scanForPeripherals() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    private func connectPeripheral() {
        centralManager.stopScan()
        centralManager.connect(connectToPeripheral, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("poweredOff")
        case .unknown:
             print("unknown")
        case .resetting:
             print("resetting")
        case .unsupported:
             print("unsupported")
        case .unauthorized:
             print("unauthorized")
        case .poweredOn:
             print("poweredOn")
            scanForPeripherals()
        @unknown default:
            print("unknown error")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let uuid = UUID(uuid: peripheral.identifier.uuid)
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("UUID=[\(uuid)] Name=[\(localName)]")
            if localName == connectToLocalName {
                connectToPeripheral = peripheral
                connectPeripheral()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralDiscoverServices()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("error:\(error)")
        } else {
            print("error:unkown")
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectToPeripheral = nil
        writeCharacteristic = nil
        notifyCharacteristic = nil
        scanForPeripherals()
    }
    
    //MARK:- CBPeripheralDelegate
    private func peripheralDiscoverServices() {
        connectToPeripheral.delegate = self
        connectToPeripheral.discoverServices(nil)
    }
    
    private func peripheralDiscoverCharacteristics(service: CBService) {
        connectToPeripheral.discoverCharacteristics(nil, for: service)
    }
    
    private func peripheralNotifyStart() {
        if let characteristic = notifyCharacteristic {
            connectToPeripheral.setNotifyValue(true, for: characteristic)
            print(characteristic.uuid)
        }
    }
    
    private func peripheralNotifyStop() {
        if let characteristic = notifyCharacteristic {
            connectToPeripheral.setNotifyValue(false, for: characteristic)
            print(characteristic.uuid)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("error:\(error)")
        } else {
            if let services = peripheral.services {
                for service in services {
                    print("service uuid = \(service.uuid.uuidString)")
                    peripheralDiscoverCharacteristics(service: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("error:\(error)")
        } else {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    print("characteristic = \(characteristic)")
                    switch characteristic.properties {
                    case .write:
                        print("write")
                        writeCharacteristic = characteristic
                    case .notify:
                        print("notify")
                        notifyCharacteristic = characteristic
                        peripheralNotifyStart()
                    default:
                        print("unknown")
                    }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if let error = error {
            print("error:\(error)")
        } else {
            print("ok")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("error:\(error) uuid:\(characteristic.uuid)")
        } else {
            print("ok uuid:\(characteristic.uuid)")
            //labelWrite(text: "notify ok")
        }
    }
   
    
    //peripheralのM5Stackからの信号の処理によりpdfを譜めくりする
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("error:\(error) uuid:\(characteristic.uuid)")
        } else {
            if let value = characteristic.value , let str = String(data: value, encoding: .utf8) {
                print("\(str)")
                DispatchQueue.main.async {
                    if str == "RED" {
                        print("BACK")
                        self.navigator.goToPreviousPage()
                    } else if str == "YELLOW" {
                        print("NONE")
                        
                    } else if str == "BLUE" {
                        print("NEXT")
                         self.navigator.goToNextPage()
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    }

    
    
    



