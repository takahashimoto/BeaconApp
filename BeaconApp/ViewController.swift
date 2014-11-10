//
//  ViewController.swift
//  BeaconApp
//
//  Created by k2-hashimoto on 2014/11/05.
//  Copyright (c) 2014年 Takahashimoto. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate{
    
    
    @IBOutlet var UuidText: UITextField!
    @IBOutlet var majorIdPicker1: UIPickerView!
    @IBOutlet var majorIdPicker2: UIPickerView!
    @IBOutlet var minorIdPicker1: UIPickerView!
    @IBOutlet var minorIdPicker2: UIPickerView!
    
    // LocationManager
    
    var myPheripheralManager:CBPeripheralManager!
    
    // Button
    
    let myButton: UIButton = UIButton()
    
    // UUID
    
    var myTextField: UITextField!
    
    // Window
    
    var myWindow: UIWindow!
    
    let myWindowButton = UIButton()
    
    // MajorId(上位)
    
    var myMajorId1: NSString = "0"
    
    // MajorId(下位)
    
    var myMajorId2: NSString = "0"
    
    // MinorId(上位)
    
    var myMinorId1: NSString = "0"
    
    // MinorId(下位)
    
    var myMinorId2: NSString = "0"
    
    // UUID
    
    var myUuid: NSString = "CB86BC31-05BD-40CC-903D-1C9BD13D966A"
    
    
    
    // 表示する値の配列.
    
    let myValues: NSArray = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
    
    let myUuids: NSArray = ["CB86BC31-05BD-40CC-903D-1C9BD13D966A"]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // PeripheralManagerを定義.
        myPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        myUuid = myUuids[0] as String
        
        let centexOfX: CGFloat = self.view.bounds.width/2
        let centerOfY: CGFloat = self.view.bounds.height/2
        
        // Picker(UUID用)
        let myMajorLabel: UILabel = UILabel(frame: CGRectMake(0, centerOfY - 120, self.view.bounds.width - 150, 20))
        myMajorLabel.text = "Major Id"
        myMajorLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(myMajorLabel)
        
        let myMinorLabel: UILabel = UILabel(frame: CGRectMake(0, centerOfY - 120, self.view.bounds.width + 150, 20))
        myMinorLabel.text = "Minor Id"
        myMinorLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(myMinorLabel)
        
        // Picker(Major/Minor用)
//        myIdPicker.frame = CGRectMake(0, centexOfX, self.view.bounds.width, 150)
//        myIdPicker.delegate = self
//        myIdPicker.dataSource = self
//        self.view.addSubview(myIdPicker)

//        majorIdPicker1.frame = CGRectMake(0, centexOfX, self.view.bounds.width, 150)
        majorIdPicker1.delegate = self
        majorIdPicker1.dataSource = self
        self.view.addSubview(majorIdPicker1)

//        majorIdPicker2.frame = CGRectMake(0, centexOfX, self.view.bounds.width, 150)
        majorIdPicker2.delegate = self
        majorIdPicker2.dataSource = self
        self.view.addSubview(majorIdPicker2)

//        minorIdPicker1.frame = CGRectMake(0, centexOfX, self.view.bounds.width, 150)
        minorIdPicker1.delegate = self
        minorIdPicker1.dataSource = self
        self.view.addSubview(minorIdPicker1)

//        minorIdPicker2.frame = CGRectMake(0, centexOfX, self.view.bounds.width, 150)
        minorIdPicker2.delegate = self
        minorIdPicker2.dataSource = self
        self.view.addSubview(minorIdPicker2)

        
        // Label(UUID用)
        let myLabel: UILabel = UILabel(frame: CGRectMake(0, centerOfY - 220, self.view.bounds.width, 20))
        myLabel.text = "UUID"
        myLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(myLabel)
        
        // Pickter(UUID用)
        UuidText.frame = CGRectMake(0, centerOfY - 250, self.view.bounds.width, 100)
        UuidText.delegate = self
        self.view.addSubview(UuidText)

        
//        myUuidPicker.frame = CGRectMake(0, centerOfY - 250, self.view.bounds.width, 100)
//        myUuidPicker.delegate = self
//        myUuidPicker.dataSource = self
//        self.view.addSubview(myUuidPicker)
        
        // サイズ
        myButton.frame = CGRectMake(0,0,80,80)
        myButton.backgroundColor = UIColor.blueColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("発信", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        myButton.layer.cornerRadius = 40.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 100)
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(myButton);
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    
    /*
    ボタンイベント
    */
    func onClickMyButton(sender: UIButton){
        
        if sender == myWindowButton {
            
            myWindow.hidden = true
            
            myButton.hidden = false
            
            myPheripheralManager.stopAdvertising()
            
        } else if sender == myButton {
            
            myWindow = UIWindow()
            
            myButton.hidden = true
            
            makeMyWindow()
            
            // iBeaconのUUID.
            let myProximityUUID = NSUUID(UUIDString: myUuid)
            
            // iBeaconのIdentifier.
            let myIdentifier = "akabeacon"
            
            // MajorId
            let myMajorString: NSString = myMajorId1 + myMajorId2
            var myMajorInt: CUnsignedInt = 0
            
            NSScanner(string: myMajorString).scanHexInt(&myMajorInt)
            let myMajorId: CLBeaconMajorValue =  CLBeaconMajorValue(myMajorInt)
            // MinorId
            let myMinorString: NSString = myMinorId1 + myMinorId2
            var myMinorInt: CUnsignedInt = 0
            
            NSScanner(string: myMinorString).scanHexInt(&myMinorInt)
            let myMinorId: CLBeaconMajorValue =  CLBeaconMajorValue(myMinorInt)
            
            // BeaconRegionを定義.
            let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID, major: myMajorId, minor: myMinorId, identifier: myIdentifier)
            
            println("uuid: \(myUuid) major:\(myMajorId) minor:\(myMinorId)")
            
            // Advertisingのフォーマットを作成.
            let myBeaconPeripheralData = myBeaconRegion.peripheralDataWithMeasuredPower(nil)
            
            // Advertisingを発信.
            myPheripheralManager.startAdvertising(myBeaconPeripheralData)
            
        }
        
    }
    
    /*
    Windowの自作
    */
    func makeMyWindow(){
        
        // 背景を白に設定
        myWindow.backgroundColor = UIColor.lightGrayColor()
        myWindow.frame = CGRectMake(0, 0, self.view.bounds.width - 50, self.view.bounds.height - 150)
        myWindow.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        myWindow.alpha = 0.8
        myWindow.layer.cornerRadius = 30
        myWindow.layer.borderColor = UIColor.blackColor().CGColor
        myWindow.layer.borderWidth = 2
        // myWindowをkeyWindowにする
        myWindow.makeKeyWindow()
        
        // windowを表示する
        self.myWindow.makeKeyAndVisible()
        
        // ボタン生成
        myWindowButton.frame = CGRectMake(0, 0, 80, 80)
        myWindowButton.backgroundColor = UIColor.redColor()
        myWindowButton.setTitle("停止", forState: .Normal)
        myWindowButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myWindowButton.layer.masksToBounds = true
        myWindowButton.layer.cornerRadius = 40.0
        myWindowButton.layer.position = CGPointMake(self.myWindow.frame.width/2, self.myWindow.frame.height-50)
        myWindowButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.myWindow.addSubview(myWindowButton)
        
        // TextView生成
        let myTextView: UITextView = UITextView(frame: CGRectMake(10, 110, self.myWindow.frame.width - 20, 150))
        myTextView.backgroundColor = UIColor.clearColor()
        myTextView.text = "iBeaconの発信を開始しました。\n\n UUID:\n\(myUuid)\n Major Id:\(myMajorId1)\(myMajorId2) \n Minor Id:\(myMinorId1)\(myMinorId2)"
        myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
        myTextView.textColor = UIColor.blackColor()
        myTextView.textAlignment = NSTextAlignment.Left
        myTextView.editable = false
        self.myWindow.addSubview(myTextView)
        
        // 表示する画像.
        let myImage: UIImage = UIImage(named: "ibeacon.png")!
        let myImageView: UIImageView = UIImageView(frame:  CGRect(x: self.myWindow.frame.width/2 - 60, y: 5, width: 100, height: 100))
        myImageView.image = myImage
        self.myWindow.addSubview(myImageView)
        
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        println("peripheralManagerDidUpdateState")
        
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        
        println("peripheralManagerDidStartAdvertising")
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1

//        if pickerView == myIdPicker {
//            
//            return 4
//            
//        } else
//            if pickerView == myUuidPicker {
//            
//            return 1
//            
//        } else {
//            
//            return 0
//            
//        }
        
    }
    
    /*
    フォントを設定
    */
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        
        var lab : UILabel = UILabel()
        
        if let label = view as? UILabel {
            
            lab = label
            
            println("reusing label")
            
        }

        
        lab.text = self.myValues[row] as? String

        lab.font = UIFont.systemFontOfSize(CGFloat(25))
            
        
//        if pickerView == myIdPicker {
//            
//            lab.text = self.myValues[row] as? String
//            
//            lab.font = UIFont.systemFontOfSize(CGFloat(25))
//            
//        } else if pickerView == myUuidPicker {
//            
//            lab.text = self.myUuids[row] as? String
//            
//            lab.font = UIFont.systemFontOfSize(CGFloat(14))
//            
//        } else {
//            
//            lab.text = self.myUuids[row] as? String
//            
//        }
        
        lab.backgroundColor = UIColor.clearColor()
        
        lab.sizeToFit()
        
        return lab
        
    }
    
    /*
    表示するデータ数.
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return myValues.count

    }
    
    /*
    値を代入.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {

        return myValues[row] as String

    }
    
    /*
    Pickerが選択された際に呼ばれる.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == majorIdPicker1 {
            
            myMajorId1 = myValues[row] as String
            
        } else if pickerView == majorIdPicker2 {
            
            myMajorId2 = myValues[row] as String
            
        } else if pickerView == minorIdPicker1 {
            
            myMinorId1 = myValues[row] as String
            
        } else if pickerView == minorIdPicker2 {
            
            myMinorId2 = myValues[row] as String
                
        }

        
    }
    
    /*
    UITextFieldが編集開始された直後に呼ばれる
    */
    func textFieldDidBeginEditing(textField: UITextField!){
        
        return;

    }
    
    /*
    UITextFieldが編集終了する直前に呼ばれる
    */
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
        
        myUuid = textField.text;
        
        
        return true;
        
    }
    
    /*
    改行ボタンが押された際に呼ばれる
    */
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }

    /* --- 下記はLSストレージ保存処理。後ほど別クラスに移植する --- */
    //--- ここから ---
    //保存のキー名
    private let UserNumber = "UserNumber"
    private let PassWord = "PassWord"

    /*
    入力された社員番号をLSに保存する
    */
    func setUserNumber(userNumber : String){
        NSUserDefaults().setValue(userNumber, forKey: UserNumber)
        NSUserDefaults().synchronize()
    }
    /*
    入力されたパスワードをLSに保存する
    */
    func setPassword(password : String){
        NSUserDefaults().setValue(password, forKey: PassWord)
        NSUserDefaults().synchronize()
    }
    //--- ここまで ---

    /*
    Logger.swift
      ログ出力時に、ファイル名、メソッド名、行を出力
      Sample : Logger.log("hogehoge")
    */
    class Logger {
        class func log(message:String,
            function:String = __FUNCTION__,
            file:String = __FILE__,
            line:Int = __LINE__){
                var filename = file
                if let match = filename.rangeOfString("[^/]*$", options: .RegularExpressionSearch){
                    filename = filename.substringWithRange(match)
                }
                println("Log:\(filename):L\(line):\(function) \"\(message)\"")
            }
    }
    
    
    
}