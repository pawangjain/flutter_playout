package tv.mta.flutter_playout_example

import android.os.Bundle
import android.view.WindowManager

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    // Adding this line will prevent taking screenshot/screen recording in your app
    // getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE,
    // WindowManager.LayoutParams.FLAG_SECURE)
  }
}
