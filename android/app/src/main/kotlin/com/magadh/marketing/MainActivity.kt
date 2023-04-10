package com.magadh.marketing
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.os.Build
import android.telephony.SmsManager
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.magadh.marketing/sim"


    fun getBatteryPercentage(): Int {
        return if (Build.VERSION.SDK_INT >= 21) {
            val bm = this.getSystemService(BATTERY_SERVICE) as BatteryManager
            return bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

        } else {
            return 0

        }
    }



        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            // This method is invoked on the main thread.
            if(call.method == "sendSms"){
                var num: String?  = call.argument("phone")
                var sms: String? = call.argument("message")
                var slot: Int? = call.argument("slot")
                var smsManager:SmsManager
                println("==================================FROM CHANNEL ======================================");
                println(slot)
                 if (slot == null) {
                    smsManager =  SmsManager.getDefault()
                } else {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        println("Executing....")
                        smsManager = SmsManager.getSmsManagerForSubscriptionId(slot)
                    } else {
                        smsManager = SmsManager.getSmsManagerForSubscriptionId(slot)
                    }
                }
                try {
                   smsManager.sendTextMessage(num, null, sms,null,null)
                } catch(e: Exception){
                    throw e
                }

                result.success("Done")
            }else if(call.method == "supportMultiSim") {
                val telephonyManager:TelephonyManager = this.getSystemService(TELEPHONY_SERVICE) as TelephonyManager
                result.success(telephonyManager.isMultiSimSupported)
            }else if(call.method == "getSimNumbers") {
                val subscription  = SubscriptionManager.from(context) as SubscriptionManager
                val activeSubscriptions: List<SubscriptionInfo> =
                    subscription.getActiveSubscriptionInfoList()
                var data:String = ""
                for(e: SubscriptionInfo in activeSubscriptions){
                    data += "@@"+"${e.simSlotIndex}-${e.carrierName}-${e.number}-${e.subscriptionId}"
                }

                result.success(data)
            }

            else if(call.method == "getBatteryLevel"){
                val level: Int = getBatteryPercentage()
                result.success(level)
            } else if(call.method == "checkpermissionstatus") {
                val permissionType:String? = call.argument("type")
                if(permissionType != null){
                   when(permissionType){
                       "camera" -> result.success(cameraPermissionStatus())
                       "backgroundLocation" -> result.success(backgroundlocation())
                       "location" -> result.success(location())
                       "storage" -> result.success(storage())
                       "mic" -> result.success(mic())
                       "phoneState" -> result.success(phoneState())
                       "phoneNumber" -> result.success(readPhoneNumber())
                       "sms" -> result.success(sms())
                   }
                }else {
                    result.notImplemented()
                }
            } else if(call.method == "requestPermission") {
                val permissionType:String? = call.argument("type")
                if(permissionType != null){
                    when(permissionType){
                        "camera" -> result.success(requestCamera())
                        "backgroundLocation" -> result.success(requestBackground())
                        "location" -> result.success(requestLocation())
                        "storage" -> result.success(requestStorage())
                        "mic" -> result.success(requestmic())
                        "phoneState" -> result.success(requestphoneState())
                    }
                    result.success(true)
                }else {
                    result.notImplemented()
                }
            }
        }

    }

    private  fun cameraPermissionStatus():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun backgroundlocation():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun location():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun storage():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun mic():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun phoneState():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun readPhoneNumber():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_PHONE_NUMBERS) == PackageManager.PERMISSION_GRANTED;
    }
    private  fun sms():Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED;
    }



    // ---------------------------Request permissions-----------------------------------------------
    private fun requestLocation():Boolean {
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION,android.Manifest.permission.ACCESS_COARSE_LOCATION),101)
        return true
    }

    private fun requestBackground():Boolean {
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.ACCESS_BACKGROUND_LOCATION),101)
        return true
    }
    private fun requestCamera(): Boolean {
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.CAMERA),101)
        return true
    }

    private fun requestmic(): Boolean {
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.RECORD_AUDIO),101)
        return true
    }

    private fun requestphoneState() :Boolean{
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.READ_PHONE_STATE,android.Manifest.permission.SEND_SMS,android.Manifest.permission.READ_PHONE_NUMBERS),101)
        return true
    }
    private fun requestStorage():Boolean {
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.READ_EXTERNAL_STORAGE, android.Manifest.permission.WRITE_EXTERNAL_STORAGE),101)
        return true
    }








}
