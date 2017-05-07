//
//  EyesOpenCalculator.swift
//  SleepyAngelHack
//
//  Created by gawawa124 on 2017/05/06.
//  Copyright © 2017年 gawawa124. All rights reserved.
//

import Foundation
import AWSCore
import AWSRekognition

class EyesOpenCalculator {
    static func calculateEyesOpen(eyesOpen: AWSRekognitionEyeOpen,
                                  smile: AWSRekognitionSmile) -> Double {
        var result: Double = 50
        
        if eyesOpen.value == true {
            result -= Double(eyesOpen.confidence ?? 0) / 4
        } else {
            result += Double(eyesOpen.confidence ?? 0) / 4
        }
        
        if smile.value == true {
            result -= Double(smile.confidence ?? 0) / 4
        } else {
            result += Double(smile.confidence ?? 0) / 4
        }
        
        return result.rounded()
    }
}
