package com.example.meatfacture

import android.app.Activity
import android.app.Application
import android.content.pm.ActivityInfo
import android.os.Bundle

class AppClass : Application() {
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks {
            override fun onActivityPaused(activity: Activity) {
//                TODO("Not yet implemented")
            }

            override fun onActivityStarted(activity: Activity) {
//                TODO("Not yet implemented")
            }

            override fun onActivityDestroyed(activity: Activity) {
//                TODO("Not yet implemented")
            }

            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
//                TODO("Not yet implemented")
            }

            override fun onActivityStopped(activity: Activity) {
//                TODO("Not yet implemented")
            }

            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
//                TODO("Not yet implemented")
                activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
            }

            override fun onActivityResumed(activity: Activity) {
//                TODO("Not yet implemented")
            }

        })
    }
}