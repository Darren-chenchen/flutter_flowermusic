package darren.com.example.flutterflowermusic;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

//import androidx.core.content.FileProvider;

import org.json.JSONObject;

import java.io.File;

import darren.com.example.flutterflowermusic.mediasession.MediaSessionManager;
import darren.com.example.flutterflowermusic.model.Song;
import darren.com.example.flutterflowermusic.tools.MusicStreamTool;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;

public class FlutterPluginBasicTest implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    public String CHANNEL = "darren.com.example.flutterFlowermusic/mutual";
    public static String CHANNELEVENT = "darren.com.example.flutterFlowermusic/event";

    MethodChannel channel;
    Context myContext;

    EventChannel channel_Event;
    EventChannel.EventSink eventSink;

    public void registerWith(PluginRegistry.Registrar registrar, Context con) {
        this.myContext = con;
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(this);

        channel_Event = new EventChannel(registrar.messenger(), CHANNELEVENT);
        channel_Event.setStreamHandler(this);

        this.setupDataToFlutter();
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
            String url = "http://businuss.client.yishouhaoge.cn:8089/#/" + "chenliang/music/single?id=" + id;
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
        if (methodCall.method.equals("beginPlay")) {
            Song song = new Song();
            song.title = (String) methodCall.argument("title");
            song.songUrl = (String) methodCall.argument("songUrl");
            song.lrcUrl = (String) methodCall.argument("lrcUrl");
            song.size = (String) methodCall.argument("size");
            song._id = (String) methodCall.argument("_id");
            song.imgUrl = (String) methodCall.argument("imgUrl");
            song.duration = (String) methodCall.argument("duration");
            song.singer = (String) methodCall.argument("singer");
            MusicStreamTool.share().initMusic(song);
        }
        if (methodCall.method.equals("pause")) {
            MusicStreamTool.share().pauseMusic();
        }
        if (methodCall.method.equals("resume")) {
            MusicStreamTool.share().playMusic();
        }
        if (methodCall.method.equals("seek")) {
            int timer = (int) methodCall.arguments;
            MusicStreamTool.share().seekMusic(timer);
        }
//        if (methodCall.method.equals("install")) {
//            String path = (String) methodCall.arguments;
//            Log.d("11111111", path);
//            String apkFilePath = path;
//            Intent intent = new Intent();
//            intent.setAction(Intent.ACTION_VIEW);
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
//                Uri contentUri = FileProvider.getUriForFile(this.myContext,
//                        this.myContext.getPackageName() + ".fileProvider", new File(apkFilePath));
//                intent.setDataAndType(contentUri, "application/vnd.android.package-archive");
//            } else {
//                intent.setDataAndType(Uri.fromFile(new File(apkFilePath)),
//                        "application/vnd.android.package-archive");
//                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            }
//            this.myContext.startActivity(intent);
//        }
    }

    private void setupDataToFlutter() {
        MusicStreamTool.share().setCurrentPlayerStateCallBack(new MusicStreamTool.MusicToolStateCallBack() {
            @Override
            public void currentPlayerState(final MusicStreamTool.MusicStreamToolState state) {
                ((MainActivity) myContext).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (state == MusicStreamTool.MusicStreamToolState.beginPlay) {
                            if (FlutterPluginBasicTest.this.eventSink != null) {
                                FlutterPluginBasicTest.this.eventSink.success("state" + "&" + "beginPlay");
                            }
                        }
                        if (state == MusicStreamTool.MusicStreamToolState.isPlaying) {
                            if (FlutterPluginBasicTest.this.eventSink != null) {
                                FlutterPluginBasicTest.this.eventSink.success("state" + "&" + "isPlaying");
                            }
                        }
                        if (state == MusicStreamTool.MusicStreamToolState.isCacheing) {
                            if (FlutterPluginBasicTest.this.eventSink != null) {
                                FlutterPluginBasicTest.this.eventSink.success("state" + "&" + "isCacheing");
                            }
                        }
                        if (state == MusicStreamTool.MusicStreamToolState.isPaued) {
                            if (FlutterPluginBasicTest.this.eventSink != null) {
                                FlutterPluginBasicTest.this.eventSink.success("state" + "&" + "playPause");
                            }
                        }
                        if (state == MusicStreamTool.MusicStreamToolState.isEnd) {
                            if (FlutterPluginBasicTest.this.eventSink != null) {
                                FlutterPluginBasicTest.this.eventSink.success("state" + "&" + "playEnd");
                            }
                        }
                        if (state == MusicStreamTool.MusicStreamToolState.isStoped) {
                            if (FlutterPluginBasicTest.this.eventSink != null) {
                                FlutterPluginBasicTest.this.eventSink.success("state" + "&" + "playStop");
                            }
                        }
                    }
                });

            }
        });
        MusicStreamTool.share().setCurrentPlayerTimerCallBack(new MusicStreamTool.MusicToolProgressCallBack() {
            @Override
            public void currentPlayerPlayTimer(int time, int totalTimer) {

                ((MainActivity) myContext).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (FlutterPluginBasicTest.this.eventSink != null) {
                            String str = String.valueOf(time) + "+" + String.valueOf(totalTimer);
                            FlutterPluginBasicTest.this.eventSink.success("progress" + "&" + str);
                        }
                    }
                });

            }
        });

        MediaSessionManager.share().setPreCallBack(new MediaSessionManager.MediaSessionManagerPreCallBack() {

            @Override
            public void preAction() {
                ((MainActivity) myContext).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (FlutterPluginBasicTest.this.eventSink != null) {
                            FlutterPluginBasicTest.this.eventSink.success("preMusic" + "&" + "111");
                        }
                    }
                });

            }
        });
        MediaSessionManager.share().setNextCallBack(new MediaSessionManager.MediaSessionManagerNextCallBack() {

            @Override
            public void nextAction() {
                ((MainActivity) myContext).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (FlutterPluginBasicTest.this.eventSink != null) {
                            FlutterPluginBasicTest.this.eventSink.success("nextMusic" + "&" + "111");
                        }
                    }
                });

            }
        });
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {

    }
}

