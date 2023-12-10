

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:push_notification/domain/entities.dart';
import 'package:push_notification/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initializeFirebaseCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  NotificationsBloc() : super(const NotificationsState()) {

    on<OnNotificationStatusChanged>(_notificationStatusChanged);
    on<OnNoficationReceived>(_notificationReceived);

    // Check notification state
    _initialStatusCheck();

    // Listen foreground messages
    _onForegroundMessage();
  }

  void _notificationStatusChanged(OnNotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit( state.copyWith( status: event.status ));
    _getFCMToken();
  }

  void _notificationReceived(OnNoficationReceived event, Emitter<NotificationsState> emit) {
    final notifications = [event.notification, ...state.notifications];
    emit( state.copyWith( notifications: notifications ));
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(OnNotificationStatusChanged(status: settings.authorizationStatus));
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    // Save $token
    print(token);
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void handleRemoteMessage( RemoteMessage message ) async {

    if (message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );

    add( OnNoficationReceived(notification: notification) );
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    add(OnNotificationStatusChanged(status: settings.authorizationStatus));
  }

  PushMessage? getMessageById( String pushMessageId ) {
    final exist = state.notifications.any((notification) => notification.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications.firstWhere((notification) => notification.messageId == pushMessageId);
  }

}
