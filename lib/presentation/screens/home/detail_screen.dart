
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:push_notification/domain/entities.dart';
import 'package:push_notification/presentation/blocs/blocs.dart';

class DetailScreen extends StatelessWidget {

  final String pushMessageId;

  const DetailScreen({
    super.key,
    required this.pushMessageId
  });

  @override
  Widget build(BuildContext context) {

    final PushMessage? message = context.watch<NotificationsBloc>().getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Detail'),
      ),
      body: message != null
        ? _DetailView(message: message)
        : const Center(
          child: Text('Notification not found'),
        ),
    );
  }
}

class _DetailView extends StatelessWidget {

  final PushMessage message;

  const _DetailView({
    required this.message
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [

          if (message.imageUrl != null)
            Image.network(message.imageUrl!),

          const SizedBox( height: 30 ),
          
          Text(message.title, style: textStyle.titleMedium),
          Text(message.body),

          const Divider(),
          Text(message.data.toString()),

        ],
      ),
    );
  }
}