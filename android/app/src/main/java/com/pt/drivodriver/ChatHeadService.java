package com.pt.drivodriver;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;

import androidx.core.app.NotificationCompat;

public class ChatHeadService extends Service {

    public static final int NOTIFICATION_ID = 75418;

    private WindowManager mWindowManager;
    private View mChatHeadView;
    private View closeBtnView;
    private ImageView chatHeadImage;
    private ImageView closeBtnImage;

    private WindowManager.LayoutParams bubbleParams;
    private Animation showAnimation;
    private Animation hideAnimation;

    double screenHeight = 0.0;
    double screenWidth = 0.0;
    double density = 0.0f;
    double navigationBarHeight = 0.0f;
    boolean stopService = false;
    String chatHeadIcon = "";
    String notificationIcon = "";
    String notificationTitle = "";
    String notificationBody = "";
    int notificationIconIdentifier = 0;
    long notificationCircleHexColor = 0;

    final Handler handler = new Handler(Looper.getMainLooper());

    int chatHeadPadding = 0;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    @SuppressLint({"ClickableViewAccessibility"})
    public int onStartCommand(Intent intent, int flags, int startId) {
        screenHeight = intent.getDoubleExtra("height", 0.0);
        screenWidth = intent.getDoubleExtra("width", 0.0);
        density = intent.getDoubleExtra("density", 0.0);
        navigationBarHeight = intent.getDoubleExtra("navigationBarHeight", 0.0);
        stopService = intent.getBooleanExtra("stopService", false);
        chatHeadIcon = intent.getStringExtra("chatHeadIcon");
        notificationIcon = intent.getStringExtra("notificationIcon");
        notificationTitle = intent.getStringExtra("notificationTitle");
        notificationBody = intent.getStringExtra("notificationBody");
        notificationCircleHexColor = intent.getLongExtra("notificationCircleHexColor", 0);

        if (notificationIcon != null) {
            String iconName = notificationIcon.replace("@drawable/", "");
            notificationIconIdentifier = getApplicationContext().getResources()
                    .getIdentifier(iconName, "drawable", getApplicationContext().getPackageName());
        }
        if (chatHeadIcon != null) {
            String iconName = chatHeadIcon.replace("@drawable/", "");
            int identifier = getApplicationContext().getResources()
                    .getIdentifier(iconName, "drawable", getApplicationContext().getPackageName());
            if (identifier != 0) {
                chatHeadImage.setImageResource(identifier);
            }
        }

        if (stopService) {
            stopSelf();
            return Service.START_STICKY_COMPATIBILITY;
        }

        createNotificationChannel();
        closeBtnView.setVisibility(View.INVISIBLE);

        handler.postDelayed(() -> {
            showAnimation = new TranslateAnimation(0, 0, closeBtnView.getHeight(), 0);
            showAnimation.setDuration(500);
            showAnimation.setFillAfter(true);

            hideAnimation = new TranslateAnimation(0, 0, 0, closeBtnView.getHeight());
            hideAnimation.setDuration(500);
            hideAnimation.setFillAfter(true);
            toggleAnimation(closeBtnImage, hideAnimation);

            chatHeadImage.setOnTouchListener(new View.OnTouchListener() {
                private int lastAction;
                private int initialX;
                private int initialY;
                private float initialTouchX;
                private float initialTouchY;

                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    switch (event.getAction()) {
                        case MotionEvent.ACTION_DOWN:
                            if (navigationBarHeight <= 24 && navigationBarHeight > 0) {
                                if (event.getRawX() < 60 || event.getRawX() > (screenWidth - 60))
                                    return false;
                            }
                            toggleAnimation(closeBtnImage, showAnimation);
                            closeBtnView.setVisibility(View.VISIBLE);

                            initialX = bubbleParams.x;
                            initialY = bubbleParams.y;

                            initialTouchX = event.getRawX();
                            initialTouchY = event.getRawY();

                            lastAction = event.getAction();
                            return true;

                        case MotionEvent.ACTION_UP:
                            toggleAnimation(closeBtnImage, hideAnimation);
                            handler.postDelayed(() -> closeBtnView.setVisibility(View.INVISIBLE), 400);

                            if (bubbleParams.x >= screenWidth / 2) {
                                bubbleParams.x = (int) screenWidth - chatHeadImage.getWidth() - chatHeadPadding;
                            } else {
                                bubbleParams.x = chatHeadPadding;
                            }
                            bubbleParams.y = initialY + (int) (event.getRawY() - initialTouchY);

                            mWindowManager.updateViewLayout(mChatHeadView, bubbleParams);

                            if (lastAction == MotionEvent.ACTION_DOWN) {
                                Intent launchIntent = new Intent(getApplicationContext(), MainActivity.class);
                                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                startActivity(launchIntent);
                                stopSelf();
                            } else {
                                double heightOfCloseBtnImage = closeBtnImage.getHeight();
                                double heightOfCloseBtnView = closeBtnView.getHeight();

                                boolean insideLeftSideOfCloseBtn =
                                        event.getRawX() > (screenWidth / 2) - (heightOfCloseBtnImage / 2);
                                boolean insideRightSideOfCloseBtn =
                                        event.getRawX() < (screenWidth / 2) + (heightOfCloseBtnImage / 2);
                                boolean reachTheBottomOfScreen = event.getRawY() > (screenHeight
                                        - (heightOfCloseBtnView + (heightOfCloseBtnView / 2)));

                                if (reachTheBottomOfScreen && insideLeftSideOfCloseBtn && insideRightSideOfCloseBtn) {
                                    bubbleParams.y = (int) (heightOfCloseBtnView - heightOfCloseBtnImage);
                                    mWindowManager.updateViewLayout(mChatHeadView, bubbleParams);
                                    toggleAnimation(closeBtnImage, hideAnimation);
                                    toggleAnimation(chatHeadImage, hideAnimation);
                                    handler.postDelayed(() -> {
                                        closeBtnView.setVisibility(View.INVISIBLE);
                                        chatHeadImage.setVisibility(View.INVISIBLE);
                                    }, 450);
                                    showServiceNotification();
                                }
                            }
                            lastAction = event.getAction();
                            return true;

                        case MotionEvent.ACTION_MOVE:
                            double heightOfCloseBtnImage = closeBtnImage.getHeight();
                            double heightOfCloseBtnView = closeBtnView.getHeight();

                            boolean insideLeftSideOfCloseBtn =
                                    event.getRawX() > (screenWidth / 2) - (heightOfCloseBtnImage / 2);
                            boolean insideRightSideOfCloseBtn =
                                    event.getRawX() < (screenWidth / 2) + (heightOfCloseBtnImage / 2);
                            boolean reachTheBottomOfScreen = event.getRawY() > (screenHeight
                                    - (heightOfCloseBtnView + (heightOfCloseBtnView / 2)));

                            if (reachTheBottomOfScreen && insideLeftSideOfCloseBtn && insideRightSideOfCloseBtn) {
                                bubbleParams.gravity = Gravity.BOTTOM;
                                bubbleParams.y = (int) (heightOfCloseBtnView - heightOfCloseBtnImage);
                                bubbleParams.x = 0;
                            } else {
                                bubbleParams.gravity = Gravity.TOP | Gravity.START;
                                bubbleParams.y = initialY + (int) (event.getRawY() - initialTouchY);
                                bubbleParams.x = initialX + (int) (event.getRawX() - initialTouchX);
                            }
                            mWindowManager.updateViewLayout(mChatHeadView, bubbleParams);
                            if (Math.abs(initialX - bubbleParams.x) > 10 || Math.abs(initialY - bubbleParams.y) > 10) {
                                lastAction = event.getAction();
                            }
                            return true;
                    }
                    return false;
                }

            });
        }, 0);

        return super.onStartCommand(intent, flags, startId);
    }

    @SuppressLint("InflateParams")
    @Override
    public void onCreate() {
        super.onCreate();
        mChatHeadView = LayoutInflater.from(this).inflate(R.layout.layout_bubble, null);
        closeBtnView = LayoutInflater.from(this).inflate(R.layout.close_button_layout, null);

        chatHeadImage = mChatHeadView.findViewById(R.id.chat_head_profile_iv);
        closeBtnImage = closeBtnView.findViewById(R.id.close_btn);

        int layoutFlag;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            layoutFlag = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        } else {
            layoutFlag = WindowManager.LayoutParams.TYPE_PHONE;
        }

        bubbleParams = createWindow(layoutFlag);
        bubbleParams.x = chatHeadPadding;
        bubbleParams.y = 120;
        bubbleParams.gravity = Gravity.TOP | Gravity.START;

        WindowManager.LayoutParams closeBtnParams = createWindow(layoutFlag);
        closeBtnParams.gravity = Gravity.BOTTOM | Gravity.CENTER;

        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);

        mWindowManager.addView(mChatHeadView, bubbleParams);
        mWindowManager.addView(closeBtnView, closeBtnParams);
    }

    private WindowManager.LayoutParams createWindow(int layoutFlag) {
        return new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                layoutFlag,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSPARENT);
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            String channelID = getString(R.string.channel_id);
            String channelName = getString(R.string.channel_name);
            String channelDescription = getString(R.string.channel_description);
            NotificationChannel channel = new NotificationChannel(channelID, channelName, importance);
            channel.setDescription(channelDescription);

            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private void showServiceNotification() {
        Intent intent = new Intent(getApplicationContext(), MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.setAction(Intent.ACTION_MAIN);

        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE);
        String channelId = getString(R.string.channel_id);

        Notification builder = new NotificationCompat.Builder(this, channelId)
                .setSmallIcon(notificationIconIdentifier == 0 ? R.drawable.logo : notificationIconIdentifier)
                .setColor(notificationCircleHexColor == 0 ? Color.TRANSPARENT : (int) notificationCircleHexColor)
                .setContentTitle(notificationTitle == null ? getApplicationName(getApplicationContext())
                        : notificationTitle)
                .setContentText(notificationBody == null ? "Your Service is still working" : notificationBody)
                .setOngoing(true)
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_HIGH).build();

        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        mNotificationManager.notify(NOTIFICATION_ID, builder);
    }

    void toggleAnimation(ImageView closeBtnImage, Animation animation) {
        closeBtnImage.startAnimation(animation);
        closeBtnImage.setVisibility(View.VISIBLE);
    }

    public static String getApplicationName(Context context) {
        ApplicationInfo applicationInfo = context.getApplicationInfo();
        int stringId = applicationInfo.labelRes;
        return stringId == 0 ? applicationInfo.nonLocalizedLabel.toString() : context.getString(stringId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        removeView();
    }

    private void removeView() {
        closeBtnView.setVisibility(View.INVISIBLE);
        if (mChatHeadView != null) {
            mWindowManager.removeView(mChatHeadView);
        }
    }
}
