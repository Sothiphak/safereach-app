import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'translations.dart';

Future<void> launchPhone(BuildContext context, String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  await _launchUri(context, uri);
}

Future<void> launchDirections(
  BuildContext context, {
  required double latitude,
  required double longitude,
}) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
  );
  await _launchUri(context, uri);
}

Future<void> _launchUri(BuildContext context, Uri uri) async {
  final canLaunch = await canLaunchUrl(uri);
  if (!canLaunch) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open external app.'.tr(context))),
      );
    }
    return;
  }
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
