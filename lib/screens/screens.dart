import 'package:app/screens/auth/supabase_profile_form.dart';
import 'package:app/screens/in_app/notification_consent_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/payment_sheet/payment_sheet_screen.dart';
import 'package:app/widgets/platform_icons.dart';

import 'auth/onesignal_form.dart';

class ExampleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool expanded;

  const ExampleSection({
    Key? key,
    required this.title,
    required this.children,
    this.expanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      initiallyExpanded: expanded,
      childrenPadding: const EdgeInsets.only(left: 20),
      title: Text(title),
      children:
          ListTile.divideTiles(tiles: children, context: context).toList(),
    );
  }
}

class Example extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Widget? leading;
  final List<DevicePlatform> platformsSupported;

  final WidgetBuilder builder;

  const Example({
    super.key,
    required this.title,
    required this.builder,
    this.style,
    this.leading,
    this.platformsSupported = DevicePlatform.values,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final route = MaterialPageRoute(builder: builder);
        Navigator.push(context, route);
      },
      title: Text(title, style: style),
      leading: leading,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: const [
        Icon(Icons.chevron_right_rounded),
      ]),
    );
  }

  static List<Example> paymentMethodScreens = [];

  static List<Widget> screens = [
    ExampleSection(title: 'Setup', expanded: true, children: [
      Example(
        title: 'Supabase',
        builder: (c) => const SupabaseProfileForm(),
      ),
      Example(
        title: 'OneSignal',
        builder: (c) => const OnesignalForm(),
      ),
    ]),
    ExampleSection(title: 'Use-cases', children: [
      Example(
        title: 'Prompt for notification consent',
        builder: (context) => const NotificationConsentScreen(),
      ),
      Example(
        title: 'Order confirmation',
        builder: (context) => const PaymentSheetScreen(),
      ),
    ]),
  ];
}
