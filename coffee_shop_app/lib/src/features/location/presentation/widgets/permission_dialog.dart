import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as LocationService;

Future<bool> showLocationPermissionDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Location Permission Required'),
      content: const Text(
        'This app needs location permissions to function properly. '
        'Please enable location permissions in app settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            LocationService.openAppSettings();
            Navigator.pop(context, true);
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  ) ?? false;
}