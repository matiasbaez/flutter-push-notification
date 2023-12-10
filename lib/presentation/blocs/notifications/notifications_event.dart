part of 'notifications_bloc.dart';

sealed class NotificationsEvent {

  const NotificationsEvent();
}

class OnNotificationStatusChanged extends NotificationsEvent {

  final AuthorizationStatus status;

  OnNotificationStatusChanged({ required this.status });
}