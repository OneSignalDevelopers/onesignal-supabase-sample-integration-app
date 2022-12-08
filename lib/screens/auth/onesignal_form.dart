import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/example_scaffold.dart';

class OnesignalForm extends StatefulWidget {
  const OnesignalForm({Key? key}) : super(key: key);

  @override
  State<OnesignalForm> createState() => _OnesignalFormState();
}

class _OnesignalFormState extends State<OnesignalForm> {
  var _loading = true;
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  OSDeviceState? _onesignalDeviceState;

  @override
  void initState() {
    _loadDevice();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _loadDevice() async {
    try {
      final state = await OneSignal.shared.getDeviceState();

      setState(() {
        _onesignalDeviceState = state;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error loading OneSignal device details.'),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailActionDesc =
        _onesignalDeviceState!.emailSubscribed ? "Disable" : "Enable";
    final pushActionDesc =
        _onesignalDeviceState!.subscribed ? "Disable" : "Enable";

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ExampleScaffold(title: 'OneSignal Messaging', children: [
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                ElevatedButton(
                    onPressed: _onesignalDeviceState!.emailSubscribed
                        ? unsubscribeEmail
                        : subscribeEmail,
                    child: Text('$emailActionDesc Email')),
                ElevatedButton(
                    onPressed: _onesignalDeviceState!.subscribed
                        ? unsubscribePush
                        : subscribePush,
                    child: Text('$pushActionDesc Push')),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Text(
                    'Subscribed to Push: ${_onesignalDeviceState?.subscribed}'),
                Text(
                    'Device ID (Push Channel): ${_onesignalDeviceState?.userId}'),
                Text(
                    'Push Enabled on Device: ${_onesignalDeviceState?.hasNotificationPermission}'),
                const SizedBox(height: 16),
                Text(
                    'Subscribed to Email: ${_onesignalDeviceState?.emailSubscribed}'),
                Text(
                    'Device ID (Email Channel): ${_onesignalDeviceState?.emailUserId}'),
                Text('Email Address: ${_onesignalDeviceState?.emailAddress}'),
                const SizedBox(height: 16),
                Text(
                    'Subscribed to SMS: ${_onesignalDeviceState?.smsSubscribed}'),
                Text(
                    'Device ID (SMS Channel): ${_onesignalDeviceState?.smsUserId}'),
                Text('SMS Number: ${_onesignalDeviceState?.smsNumber}')
              ],
            )
          ]);
  }

  Future<void> subscribePush() async {
    setState(() {
      _loading = true;
    });

    try {
      await OneSignal.shared.disablePush(false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error setting email'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> unsubscribePush() async {
    setState(() {
      _loading = true;
    });

    try {
      await OneSignal.shared.disablePush(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error setting email'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> subscribeEmail() async {
    setState(() {
      _loading = true;
    });

    try {
      final email = Supabase.instance.client.auth.currentUser!.email!;
      await OneSignal.shared.setEmail(email: email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error setting email'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> unsubscribeEmail() async {
    setState(() {
      _loading = true;
    });

    try {
      await OneSignal.shared.logoutEmail();
      await _loadDevice();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error setting email'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _loading = false;
    });
  }
}
