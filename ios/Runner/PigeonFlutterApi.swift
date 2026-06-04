//
//  PigeonFlutterApi.swift
//  Runner
//
//  Created by 戴培琼 on 2024/11/25.
//

import Foundation

public class PigeonFlutterApi {
  var flutterAPI: FlutterClientApi

  init(binaryMessenger: FlutterBinaryMessenger) {
    flutterAPI = FlutterClientApi(binaryMessenger: binaryMessenger)
  }
    


  
}
