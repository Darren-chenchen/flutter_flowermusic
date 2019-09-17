package darren.com.example.flutterflowermusic.mediasession;

import android.util.Log;

import darren.com.example.flutterflowermusic.App;
import darren.com.example.flutterflowermusic.tools.MusicStreamTool;

import android.support.v4.media.MediaMetadataCompat;
import android.support.v4.media.session.MediaSessionCompat;
import android.support.v4.media.session.PlaybackStateCompat;


public class MediaSessionManager {

    // 静态内部类单例模式
    private MediaSessionManager(){
        initSession();
    }
    public static synchronized MediaSessionManager share() {
        MediaSessionManager tools = MediaSessionManagerHolder.instance;
        return tools;
    }
    public static class MediaSessionManagerHolder {

        private static final MediaSessionManager instance = new MediaSessionManager();
    }

    private static final String MY_MEDIA_ROOT_ID = "MediaSessionManager";

    MediaSessionCompat mMediaSession;
    private PlaybackStateCompat.Builder stateBuilder;
    private MusicStreamTool musicPlayService = MusicStreamTool.share();

    // 定义回调函数
    public interface MediaSessionManagerNextCallBack {
        public void nextAction();
    }
    public interface MediaSessionManagerPreCallBack {
        public void preAction();
    }

    MediaSessionManagerNextCallBack nextCallBack;
    public void setNextCallBack(MediaSessionManagerNextCallBack callBack) {
        this.nextCallBack = callBack;
    }
    MediaSessionManagerPreCallBack preCallBack;
    public void setPreCallBack(MediaSessionManagerPreCallBack callBack) {
        this.preCallBack = callBack;
    }

    public void initSession() {
        try {
            Log.d("11111", "------");
            mMediaSession = new MediaSessionCompat(App.getContext(), MY_MEDIA_ROOT_ID);
            mMediaSession.setFlags(MediaSessionCompat.FLAG_HANDLES_MEDIA_BUTTONS | MediaSessionCompat.FLAG_HANDLES_TRANSPORT_CONTROLS);
            stateBuilder = new PlaybackStateCompat.Builder()
                    .setActions(PlaybackStateCompat.ACTION_PLAY | PlaybackStateCompat.ACTION_PLAY_PAUSE
                            | PlaybackStateCompat.ACTION_SKIP_TO_NEXT | PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS);
            mMediaSession.setPlaybackState(stateBuilder.build());
            mMediaSession.setCallback(sessionCb);
            mMediaSession.setActive(true);
        } catch (Exception e) {
        }
    }

    public void updatePlaybackState() {
        int state = 0;
        if (MusicStreamTool.share().currentState == MusicStreamTool.MusicStreamToolState.isPlaying) {
            state = PlaybackStateCompat.STATE_PLAYING;
        } else {
            state = PlaybackStateCompat.STATE_PAUSED;
        }
        long position = 0;
        if (MusicStreamTool.share().currentState == MusicStreamTool.MusicStreamToolState.isPlaying) {
            position = MusicStreamTool.share().player.getCurrentPosition();
        }
        if (stateBuilder != null) {
            stateBuilder.setState(state, position, 1.0f);
            mMediaSession.setPlaybackState(stateBuilder.build());
        }
    }

    public void updateLocMsg() {
        try {
            //同步歌曲信息
            MediaMetadataCompat.Builder md = new MediaMetadataCompat.Builder();
            md.putString(MediaMetadataCompat.METADATA_KEY_TITLE, MusicStreamTool.share().currentSong.title);
            md.putString(MediaMetadataCompat.METADATA_KEY_ARTIST, MusicStreamTool.share().currentSong.singer);
            md.putString(MediaMetadataCompat.METADATA_KEY_ALBUM, MusicStreamTool.share().currentSong.singer);
            if (MusicStreamTool.share().currentState == MusicStreamTool.MusicStreamToolState.isPlaying) {
                md.putLong(MediaMetadataCompat.METADATA_KEY_DURATION, MusicStreamTool.share().player.getDuration());
            }
            mMediaSession.setMetadata(md.build());
        } catch (Exception e) {
        }

    }

    private MediaSessionCompat.Callback sessionCb = new MediaSessionCompat.Callback() {
        @Override
        public void onPlay() {
            super.onPlay();
            Log.d("--", "onPlay");
            MusicStreamTool.share().playMusic();
        }

        @Override
        public void onPause() {
            super.onPause();
            Log.d("--", "onPause");
            MusicStreamTool.share().pauseMusic();
        }

        @Override
        public void onSkipToNext() {
            super.onSkipToNext();
            if (MediaSessionManager.this.nextCallBack != null) {
                MediaSessionManager.this.nextCallBack.nextAction();
            }
        }

        @Override
        public void onSkipToPrevious() {
            super.onSkipToPrevious();
            if (MediaSessionManager.this.preCallBack != null) {
                MediaSessionManager.this.preCallBack.preAction();
            }
        }

    };

    public void release() {
        mMediaSession.setCallback(null);
        mMediaSession.setActive(false);
        mMediaSession.release();
    }

}
