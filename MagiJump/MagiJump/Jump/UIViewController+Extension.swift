//
//  UIViewController+Extension.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/15.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String) {
        let alertController = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alertController.addAction(alertAction)
        present(alertController,
                animated: true,
                completion: nil)
    }
    
}
