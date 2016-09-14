//
//  lwm2m_id.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit

class lwm2m_id: NSObject {
    
    /***
     CTRL : CONTROL
     DIGI : DIGITAL
     OUT  : OUTPUT
     VAL  : VALUE
     ANAL : ANALOG
     ***/
    
    static let LWM2MID_DEVICE    = "3"
    
    /*** LWM2M Object ID ***/
    static let LWM2MID_DIGI_IN          = "3200"    // button
    static let LWM2MID_DIGI_OUT         = "3201"    // LED control
    static let LWM2MID_ANAL_IN          = "3202"
    static let LWM2MID_ANAL_OUT         = "3203"
    
    static let LWM2MID_SENSOR           = "3300"	// Generic sensor
    static let LWM2MID_ILLUMINANCE      = "3301"	// Lux of light
    static let LWM2MID_PRESENCE         = "3302"
    static let LWM2MID_TEMPERATURE      = "3303"
    static let LWM2MID_HUMIDITY         = "3304"
    static let LWM2MID_LIGHT_CTRL       = "3311"
    static let LWM2MID_POWER_CTRL       = "3312"
    static let LWM2MID_ACCELEROMETER    = "3313"
    static let LWM2MID_MAGNETOMETER     = "3314"
    static let LWM2MID_BAROMETER        = "3315"
    static let LWM2MID_PRESSURE         = "3323"
    static let LWM2MID_LOUDNESS         = "3324"
    static let LWM2MID_CONCENTRATION    = "3325"	// PM2.5
    static let LWM2MID_DISTANCE         = "3330"	// Sonar
    static let LWM2MID_GYROMETER        = "3334"
    static let LWM2MID_COLOR            = "3335"
    static let LWM2MID_BUZZER           = "3338"
    static let LWM2MID_PUSH_BUTTON      = "3347"
    
    /*** Object ID used for Nuvoton internal ***/
    static let LWM2MID_VIBRATION        = "3902"
    static let LWM2MID_GAS_LEVEL        = "3903"
    
    /*** LWM2M Resource ID ***/
    static let LWM2MID_DIGI_IN_STATE    = "5500"
    static let LWM2MID_SENSOR_VAL       = "5700"	// Float
    static let LWM2MID_SENSOR_UNIT      = "5701"	// String
    static let LWM2MID_X_VAL            = "5702"	// Float
    static let LWM2MID_Y_VAL            = "5703"	// Float
    static let LWM2MID_Z_VAL            = "5704"	// Float
    static let LWM2MID_COLOUR           = "5706"	// Color
    
    static let LWM2MID_ON_OFF           = "5850"	// Boolean, 0/1 is off/on. post
    static let LWM2MID_DIMMER           = "5851"	// Integer, 0-100, percentage.
    static let LWM2MID_MULTI_STATE_OUT  = "5853"	// String. bidirectional, get and post
    
}
