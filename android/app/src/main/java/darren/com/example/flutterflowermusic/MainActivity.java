package darren.com.example.flutterflowermusic;

import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  MethodChannel channel;
  public String CHANNEL = "darren.com.example.flutterFlowermusic/mutual";

  FlutterPluginBasicTest pluginBasicTest = new FlutterPluginBasicTest();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    this.registerFor(this);
    Log.d("1111", "1111");
  }

  public void registerFor(PluginRegistry registrar) {
    pluginBasicTest.registerWith(registrar.registrarFor(CHANNEL), this);
  }
}
