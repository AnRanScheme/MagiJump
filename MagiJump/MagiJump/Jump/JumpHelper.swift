//
//  JumpHelper.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/15.
//  Copyright © 2018年 anran. All rights reserved.
//

enum NextDirection: Int {
    case left       = 0
    case right      = 1
}

import UIKit

class JumpHelper: NSObject {
    // 纪录最高分数
    private let kHeightScoreKey = "highest_score"
    
    private override init() {
        
    }
    
    static let shared: JumpHelper = JumpHelper()
    
    func getHighestScore() -> Int {
        return UserDefaults.standard.integer(forKey: kHeightScoreKey)
    }
    
    func setHighestScore(_ score: Int) {
        if score > getHighestScore() {
            UserDefaults.standard.set(score, forKey: kHeightScoreKey)
            UserDefaults.standard.synchronize()
        }
    }
    
}

