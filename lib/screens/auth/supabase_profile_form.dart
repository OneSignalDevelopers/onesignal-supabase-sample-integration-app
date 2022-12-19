import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/example_scaffold.dart';

class SupabaseProfileForm extends StatefulWidget {
  const SupabaseProfileForm({Key? key}) : super(key: key);

  @override
  State<SupabaseProfileForm> createState() => _SupabaseProfileFormState();
}

class _SupabaseProfileFormState extends State<SupabaseProfileForm> {
  var _loading = false;
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void initState() {
    _loadProfile();

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
        : ExampleScaffold(title: 'Supabase Auth', children: [
            ListView(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      label: Text('Username'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _websiteController,
                    decoration: const InputDecoration(
                      label: Text('Website'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            _loading = true;
                          });
                          final userId =
                              Supabase.instance.client.auth.currentUser!.id;
                          final email =
                              Supabase.instance.client.auth.currentUser!.email;
                          final username = _usernameController.text;
                          final website = _websiteController.text;
                          await Supabase.instance.client
                              .from('profiles')
                              .upsert({
                            'id': userId,
                            'username': username,
                            'website': website,
                            'email': email
                          });

                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Saved profile'),
                            ));
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Error saving profile'),
                            backgroundColor: Colors.red,
                          ));
                        }
                        setState(() {
                          _loading = false;
                        });
                      },
                      child: const Text('Save')),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: () => Supabase.instance.client.auth.signOut(),
                      child: const Text('Sign Out')),
                ])
          ]);
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = false;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final data = await Supabase.instance.client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        setState(() {
          _usernameController.text = data['username'] ?? '';
          _websiteController.text = data['website'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error occurred while getting profile'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _loading = false;
    });
  }
}
