package darren.com.example.flutterflowermusic;

import android.util.Log;
import android.widget.Toast;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;

public class FlutterPluginBasicTest implements MethodChannel.MethodCallHandler {

    public static String CHANNEL = "darren.com.example.flutterFlowermusic/mutual";

    static MethodChannel channel;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        FlutterPluginBasicTest instance = new FlutterPluginBasicTest();
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("GoodComment")) {
            Log.d("GoodComment", "GoodComment");
            //返回给flutter的参数
            result.success("success");
        }
    }
}

