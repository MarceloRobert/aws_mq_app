import 'package:aws_mq_app/service_stomp.dart';
import 'package:flutter/material.dart';

StompServices sharedSocket = StompServices();
final GlobalKey<ScaffoldMessengerState> sharedSMS =
    GlobalKey<ScaffoldMessengerState>();

Map<String, dynamic> sharedUser = {
  'uuid': "",
  'equipamento': "",
};
