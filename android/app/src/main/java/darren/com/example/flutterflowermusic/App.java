package darren.com.example.flutterflowermusic;

import android.content.Context;
import android.util.Log;

import androidx.multidex.MultiDex;

import io.flutter.app.FlutterApplication;

public class App extends FlutterApplication {

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
        Log.d("222", "22222");
    }
}
