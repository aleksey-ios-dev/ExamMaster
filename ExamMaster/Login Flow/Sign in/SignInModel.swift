//
//  SignInModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//


//Обратный вызов реализован при помощи Bubble Notification
//LoginFlowModel объявляет свой домен для этих уведомлений и перехватывает их на всплытии.
//Удобно для доставки сообщения вверх через несколько посредников

import Foundation
import ModelsTreeKit

class SignInModel: Model {
  
  func register() {
    raiseBubbleNotification(Bubble.LoginFlow.Register, sender: self)
  }
}