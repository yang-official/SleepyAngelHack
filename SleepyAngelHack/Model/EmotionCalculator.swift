//
//  EmotionCalculator.swift
//  SleepyAngelHack
//
//  Created by gawawa124 on 2017/05/06.
//  Copyright © 2017年 gawawa124. All rights reserved.
//

import Foundation
import AWSCore
import AWSRekognition

class EmotionCalculator {
    static func calculate(emotions: [AWSRekognitionEmotion]) -> Int {
        
        var result = 0
        
        for emotion in emotions {
            switch emotion.types {
            case .unknown:
                result += Int(emotion.confidence ?? 0) * 0
            case .happy:
                result += Int(emotion.confidence ?? 0) * 1
            case .sad:
                result += Int(emotion.confidence ?? 0) * 2
            case .angry:
                result += Int(emotion.confidence ?? 0) * 3
            case .confused:
                result += Int(emotion.confidence ?? 0) * 4
            case .disgusted:
                result += Int(emotion.confidence ?? 0) * 5
            case .surprised:
                result += Int(emotion.confidence ?? 0) * 6
            case .calm:
                result += Int(emotion.confidence ?? 0) * 7
            }
        }
        
        return result
    }
}
