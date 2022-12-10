import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/example_scaffold.dart';

class OnesignalForm extends StatefulWidget {
  const OnesignalForm({Key? key}) : super(key: key);

  @override
  State<OnesignalForm> createState() => _OnesignalFormState();
}

enum MessageChannel { push, email, sms }

class _OnesignalFormState extends State<OnesignalForm> {
  var _loading = false;
  var _updatingPush = false;
  var _updatingEmail = false;
  var _updatingSms = false;

  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _user = Supabase.instance.client.auth.currentUser!;

  OSDeviceState? _onesignalDeviceState;
  MessageChannel? _preferredChannel;

  @override
  void initState() {
    setState(() {
      _loading = true;
    });

    _loadDevice();

    setState(() {
      _loading = false;
    });

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ExampleScaffold(title: 'OneSignal Settings', children: [
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                const Text('Enabled Channels', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 14),
                SwitchListTile(
                  title: const Text('Push'),
                  value: _onesignalDeviceState?.subscribed ?? false,
                  onChanged: _onPushSwitchChanged,
                ),
                SwitchListTile(
                    title: const Text('Email'),
                    value: _onesignalDeviceState?.emailSubscribed ?? false,
                    onChanged: _onEmailSwitchChanged),

                SwitchListTile(
                  title: const Text('SMS'),
                  value: false,
                  onChanged: _onSmsSwitchChanged,
                ),
                const SizedBox(height: 16),
                const Text('Preferred Channel', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 14),
                Column(
                  children: [
                    ListTile(
                      title: const Text('Push'),
                      leading: Radio<MessageChannel>(
                        value: MessageChannel.push,
                        groupValue: _preferredChannel,
                        onChanged: (value) async {
                          await _updateChannelPreference(value!);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Email'),
                      leading: Radio<MessageChannel>(
                        value: MessageChannel.email,
                        groupValue: _preferredChannel,
                        onChanged: (value) async {
                          await _updateChannelPreference(value!);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('SMS'),
                      enableFeedback: false,
                      leading: Radio<MessageChannel>(
                        value: MessageChannel.sms,
                        groupValue: _preferredChannel,
                        onChanged: (value) async {
                          await _updateChannelPreference(value!);
                        },
                      ),
                    )
                  ],
                ),
                // const SizedBox(height: 16),
                // const SizedBox(height: 16),
                // Text(
                //     'Subscribed to Push: ${_onesignalDeviceState?.subscribed}'),
                // Text(
                //     'Device ID (Push Channel): ${_onesignalDeviceState?.userId}'),
                // Text(
                //     'Push Enabled on Device: ${_onesignalDeviceState?.hasNotificationPermission}'),
                // const SizedBox(height: 16),
                // Text(
                //     'Subscribed to Email: ${_onesignalDeviceState?.emailSubscribed}'),
                // Text(
                //     'Device ID (Email Channel): ${_onesignalDeviceState?.emailUserId}'),
                // Text('Email Address: ${_onesignalDeviceState?.emailAddress}'),
                // const SizedBox(height: 16),
                // Text(
                //     'Subscribed to SMS: ${_onesignalDeviceState?.smsSubscribed}'),
                // Text(
                //     'Device ID (SMS Channel): ${_onesignalDeviceState?.smsUserId}'),
                // Text('SMS Number: ${_onesignalDeviceState?.smsNumber}')
              ],
            )
          ]);
  }

  Future<void> _loadDevice() async {
    try {
      final state = await OneSignal.shared.getDeviceState();
      final preferredChannel = await Supabase.instance.client
          .from('profiles')
          .select('message_channel_preference')
          .eq('id', _user.id);

      setState(() {
        _onesignalDeviceState = state;

        switch (preferredChannel[0]["message_channel_preference"]) {
          case 'MessageChannel.email':
            _preferredChannel = MessageChannel.email;
            break;
          case 'MessageChannel.push':
            _preferredChannel = MessageChannel.push;
            break;
          case 'MessageChannel.sms':
            _preferredChannel = MessageChannel.sms;
            break;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error loading OneSignal device details.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _onPushSwitchChanged(bool enable) async {
    if (_updatingPush) return;

    setState(() {
      _updatingPush = true;
    });

    try {
      await OneSignal.shared.disablePush(!enable);
      await _loadDevice();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Push channel ${enable ? 'enabled' : 'disabled'}"),
          backgroundColor: Colors.blue,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not enable Push channel.'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _updatingPush = false;
    });
  }

  Future<void> _onEmailSwitchChanged(bool enable) async {
    if (_updatingEmail) return;

    setState(() {
      _updatingEmail = true;
    });

    try {
      if (enable) {
        final email = Supabase.instance.client.auth.currentUser!.email!;
        await OneSignal.shared.setEmail(email: email);
      } else {
        await OneSignal.shared.logoutEmail();
      }

      await _loadDevice();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email channel ${enable ? 'enabled' : 'disabled'}"),
          backgroundColor: Colors.blue,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not enable Email channel.'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _updatingEmail = false;
    });
  }

  Future<void> _onSmsSwitchChanged(bool enable) async {
    if (_updatingSms) return;

    setState(() {
      _updatingSms = true;
    });

    setState(() {
      _updatingSms = false;
    });
  }

  Future<void> _updateChannelPreference(MessageChannel preference) async {
    if (preference == MessageChannel.sms) return;

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      await Supabase.instance.client.from('profiles').update(
          {'message_channel_preference': '$preference'}).eq('id', userId);

      setState(() {
        _preferredChannel = preference;
      });

      await _loadDevice();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Preferred channel saved.'),
          backgroundColor: Colors.blue,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error saving message channel preference.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
