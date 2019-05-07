package darren.com.example.flutterflowermusic;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONObject;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;

public class FlutterPluginBasicTest implements MethodChannel.MethodCallHandler {

    public String CHANNEL = "darren.com.example.flutterFlowermusic/mutual";

    MethodChannel channel;
    Context myContext;

    public void registerWith(PluginRegistry.Registrar registrar, Context con) {
        this.myContext = con;
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("GoodComment")) {
            Log.d("GoodComment", "GoodComment");
            //返回给flutter的参数
            result.success("success");
        }
        if (methodCall.method.equals("share")) {
            Log.d("share", "share");
            System.out.println(String.valueOf(methodCall.arguments));
            String id = (String) methodCall.argument("_id");
            System.out.println(id);
            String url = "http://chenliang.yishouhaoge.cn/#/" + "chenliang/music/single?id=" + id;
            Intent share_intent = new Intent();
            share_intent.setAction(Intent.ACTION_SEND);//设置分享行为
            share_intent.setType("text/plain");//设置分享内容的类型
            share_intent.putExtra(Intent.EXTRA_SUBJECT, "this song is so nice");//添加分享内容标题
            share_intent.putExtra(Intent.EXTRA_TEXT, url);//添加分享内容
            //创建分享的Dialog
            share_intent = Intent.createChooser(share_intent, "分享");
            this.myContext.startActivity(share_intent);

            //返回给flutter的参数
            result.success("success");
        }
    }
}

