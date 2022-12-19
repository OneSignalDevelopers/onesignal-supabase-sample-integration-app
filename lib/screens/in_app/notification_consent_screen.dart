import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../widgets/example_scaffold.dart';

class NotificationConsentScreen extends StatefulWidget {
  const NotificationConsentScreen({Key? key}) : super(key: key);

  @override
  State<NotificationConsentScreen> createState() =>
      _NotificationConsentScreenState();
}

class _NotificationConsentScreenState extends State<NotificationConsentScreen> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(title: 'In-App Messages', children: [
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          ElevatedButton(
              onPressed: promptForConsent,
              child: const Text('Prompt Notification Consent')),
        ],
      )
    ]);
  }

  Future<void> promptForConsent() async {
    try {
      await OneSignal.shared.addTrigger("prompt_notification", "true");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error setting email'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
