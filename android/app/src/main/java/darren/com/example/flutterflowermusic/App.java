package darren.com.example.flutterflowermusic;

import android.content.Context;
import android.util.Log;

import androidx.multidex.MultiDex;

import io.flutter.app.FlutterApplication;

public class App extends FlutterApplication {

    private static Context context;

    @Override
    public void onCreate() {
        super.onCreate();
        context = this;
    }
    /**
     * 获取全局上下文*/
    public static Context getContext(){
        return context;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
        Log.d("222", "22222");
    }
}
