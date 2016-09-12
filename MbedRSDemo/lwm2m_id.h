

#ifndef _LWM2M_ID_H_
#define _LWM2M_ID_H_

/***
  CTRL : CONTROL
  DIGI : DIGITAL
  OUT  : OUTPUT
  VAL  : VALUE
  ANAL : ANALOG
 ***/

#define LWM2MID_DEVICE			"3"

/*** LWM2M Object ID ***/

#define LWM2MID_DIGI_IN			"3200"
#define LWM2MID_DIGI_OUT		"3201"
#define LWM2MID_ANAL_IN			"3202"
#define LWM2MID_ANAL_OUT		"3203"

#define LWM2MID_SENSOR			"3300"	// Generic sensor
#define LWM2MID_ILLUMINANCE		"3301"	// Lux of light
#define LWM2MID_PRESENCE		"3302"
#define LWM2MID_TEMPERATURE		"3303"
#define LWM2MID_HUMIDITY		"3304"
#define LWM2MID_LIGHT_CTRL		"3311"
#define LWM2MID_POWER_CTRL		"3312"
#define LWM2MID_ACCELEROMETER	"3313"
#define LWM2MID_MAGNETOMETER	"3314"
#define LWM2MID_BAROMETER		"3315"
#define LWM2MID_PRESSURE		"3323"
#define LWM2MID_LOUDNESS		"3324"
#define LWM2MID_CONCENTRATION	"3325"	// PM2.5
#define LWM2MID_DISTANCE		"3330"	// Sonar
#define LWM2MID_GYROMETER		"3334"
#define LWM2MID_COLOR			"3335"
#define LWM2MID_BUZZER			"3338"
#define LWM2MID_PUSH_BUTTON		"3347"

/*** Object ID used for Nuvoton internal ***/
#define LWM2MID_VIBRATION		"3902"
#define LWM2MID_GAS_LEVEL		"3903"

/*** LWM2M Resource ID ***/

#define LWM2MID_DIGI_IN_STATE	"5500"
#define LWM2MID_SENSOR_VAL		"5700"	// Float
#define LWM2MID_SENSOR_UNIT		"5701"	// String
#define LWM2MID_X_VAL			"5702"	// Float
#define LWM2MID_Y_VAL			"5703"	// Float
#define LWM2MID_Z_VAL			"5704"	// Float
#define LWM2MID_COLOUR			"5706"	// Color

#define LWM2MID_ON_OFF			"5850"	// Boolean, 0/1 is off/on
#define LWM2MID_DIMMER			"5851"	// Integer, 0-100, percentage
#define LWM2MID_MULTI_STATE_OUT	"5853"	// String

#endif
