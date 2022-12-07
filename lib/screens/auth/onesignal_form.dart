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
    try {} catch (e) {
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
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ExampleScaffold(title: 'OneSignal', children: [
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                ElevatedButton(
                    onPressed: setEmail, child: const Text('Enable Email')),
                ElevatedButton(
                    onPressed: getDeviceState,
                    child: const Text('Load Device State'))
              ],
            )
          ]);
  }

  Future<void> setEmail() async {
    try {
      setState(() {
        _loading = true;
      });
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

  Future<void> getDeviceState() async {
    try {
      setState(() {
        _loading = true;
      });

      final state = await OneSignal.shared.getDeviceState();
      print(state);
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
