import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationMessage {
  final String title;
  final String body;
  final String imageUrl;
  PushNotificationMessage({
    @required this.title,
    @required this.body,
    @required this.imageUrl,
  });
}