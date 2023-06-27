import 'package:hidroponia/service_stomp.dart';
import 'package:flutter/material.dart';

StompServices sharedSocket = StompServices();
final GlobalKey<ScaffoldMessengerState> sharedSMS =
    GlobalKey<ScaffoldMessengerState>();

Map<String, dynamic> sharedUser = {
  'cli_id': "",
  'equipamento': "",
  'amb_id': "",
};
