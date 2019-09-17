package darren.com.example.flutterflowermusic.tools;

import android.app.IntentService;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import darren.com.example.flutterflowermusic.constant.MusicConstants;
import darren.com.example.flutterflowermusic.mediasession.MediaSessionManager;
import darren.com.example.flutterflowermusic.model.Song;

import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;


public class MusicStreamTool extends IntentService {
    private Handler mHandler = new Handler(Looper.getMainLooper());
    // 静态内部类单例模式
    public MusicStreamTool(){
        super("music");
    }

    public static synchronized MusicStreamTool share() {
        MusicStreamTool tools = MusicStreamToolHolder.instance;
        return tools;
    }
    public static class MusicStreamToolHolder {
        private static final MusicStreamTool instance = new MusicStreamTool();
    }

    // 变量初始化
    public MediaPlayer player;
    // 定时器
    private Timer timer = new Timer("musicTimer");
    // 定时任务
    private MytimerTask tmTask = null;
    // 当前的状态
    public MusicStreamToolState currentState;

    public enum MusicStreamToolState {
        beginPlay, isPlaying, isPaued, isCacheing, isStoped, isEnd;
    }
    // 定义回调函数
    public interface MusicToolIndexCallBack {
        public void currentPlayerIndex(int index);
    }
    public interface MusicToolStateCallBack {
        public void currentPlayerState(MusicStreamToolState isStoped);
    }
    public interface MusicToolProgressCallBack {
        public void currentPlayerPlayTimer(int time, int duration);
    }

    // 下标的回调
    MusicToolIndexCallBack currentIndexCallBack;
    public void setCurrentPlayerIndexCallBack(MusicToolIndexCallBack callBack) {
        this.currentIndexCallBack = callBack;
    }
    MusicToolStateCallBack currentStateCallBack;
    public void setCurrentPlayerStateCallBack(MusicToolStateCallBack callBack) {
        this.currentStateCallBack = callBack;
    }
    MusicToolProgressCallBack currentPlayTimeCallBack;
    public void setCurrentPlayerTimerCallBack(MusicToolProgressCallBack callBack) {
        this.currentPlayTimeCallBack = callBack;
    }

    public Song currentSong;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        handleIntent(intent);
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);

        return START_STICKY;
    }
    private void handleIntent(Intent intent) {
        if (intent == null || intent.getAction() == null) {
            return;
        }
        switch (intent.getAction()) {
            case MusicConstants.MUSIC_ACTICON_START_PLAY:
                playMusic();
                break;
            case MusicConstants.MUSIC_ACTICON_PAUSE_PLAY:
                pauseMusic();
                break;
            case MusicConstants.MUSIC_ACTICON_CONTINUE_PLAY:
                playMusic();
                break;
            case MusicConstants.MUSIC_ACTICON_RESET_START_PLAY:
                playMusic();
                break;
            case MusicConstants.MUSIC_ACTICON_PLAY_PRE:  /// 上一曲
                Log.d("1111", "上一曲");
                break;
            case MusicConstants.MUSIC_ACTICON_PLAY_NEXT: /// 下一曲
                Log.d("1111", "下一曲");
                break;
        }
    }

    // 开始播放
    public void initMusic(Song song) {
        this.currentSong = song;

        try {
            this.relesePlayer();

            setupMusicState(MusicStreamToolState.isStoped);

            this.player = new MediaPlayer();
            Log.d("音乐的连接", song.songUrl);
//            String finishStr = Uri.encode(song.songUrl, "utf-8");
            this.player.setDataSource(song.songUrl);
            this.player.prepareAsync(); // 异步的方式装载流媒体资源
            setupMusicState(MusicStreamToolState.beginPlay);

            player.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer mp) {
                    // 装载完毕回调
                    playMusic();

                    startTimer();

                }
            });
            player.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mediaPlayer) {
                    setupMusicState(MusicStreamToolState.isEnd);
                }
            });
            player.setOnBufferingUpdateListener(new MediaPlayer.OnBufferingUpdateListener() {
                @Override
                public void onBufferingUpdate(MediaPlayer mediaPlayer, int i) { // 缓冲进度
                }
            });
            player.setOnVideoSizeChangedListener(new MediaPlayer.OnVideoSizeChangedListener() {
                @Override
                public void onVideoSizeChanged(MediaPlayer mediaPlayer, int i, int i1) {
                    System.out.println(mediaPlayer.getDuration());
                }
            });
            player.setOnErrorListener(new MediaPlayer.OnErrorListener() {
                @Override
                public boolean onError(MediaPlayer mediaPlayer, int i, int i1) {
                    stopTimer();
                    return false;
                }
            });
            player.setOnInfoListener(new MediaPlayer.OnInfoListener() {
                @Override
                public boolean onInfo(MediaPlayer mediaPlayer, int i, int i1) {
                    if (i == 701) { // 暂停播放开始缓冲更多数据
                        setupMusicState(MusicStreamToolState.isCacheing);
                    }
                    if (i == 702) { // 缓冲了足够的数据重新开始播放
                        setupMusicState(MusicStreamToolState.isPlaying);
                    }
                    return false;
                }
            });
        } catch(Exception e){
            this.stopTimer();
            Log.d("播放错误", song.songUrl);
            System.out.println(e);
        };
    }
    public void relesePlayer() {
        if (player != null) {
            if (player.isPlaying()) {
                player.stop();
            }
            player.release();
            player = null;
            this.stopTimer();
        }
    }

    public void playMusic() {
        this.player.start();
        setupMusicState(MusicStreamToolState.isPlaying);
        this.startTimer();
    }
    public void pauseMusic() {
        this.player.pause();
        setupMusicState(MusicStreamToolState.isPaued);
        this.stopTimer();
    }

    // 开启定时器
    public void startTimer(){
        if (tmTask != null) {
            this.stopTimer();
        }
        timer.purge();
        if(tmTask==null){
            tmTask = new MytimerTask();
        }
        timer.schedule(tmTask, new Date(), 1000);
    }
    // 关闭定时器
    public void stopTimer(){
        if(tmTask!=null) {
            tmTask.cancel();
            tmTask = null;//如果不重新new，会报异常
        }
    }
    public void seekMusic(int timer) {
        this.player.seekTo(timer * 1000);
    }
    // 设置状态
    private void setupMusicState(MusicStreamToolState state) {
        if (currentStateCallBack != null) {
            currentStateCallBack.currentPlayerState(state);
            this.currentState = state;

            MediaSessionManager.share().updatePlaybackState();
            MediaSessionManager.share().updateLocMsg();
        }

    }
}

class MytimerTask extends TimerTask {

    @Override
    public void run() {

        if (MusicStreamTool.share().currentState == MusicStreamTool.MusicStreamToolState.isPlaying) {
            int pos = MusicStreamTool.share().player.getCurrentPosition();
            double duration = MusicStreamTool.share().player.getDuration();

            if (MusicStreamTool.share().currentPlayTimeCallBack != null) {
                MusicStreamTool.share().currentPlayTimeCallBack.currentPlayerPlayTimer(pos/1000, (int) (duration/1000));
            }
        }
    }
}