import 'package:app/screens/auth/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/payment_sheet/payment_sheet_screen.dart';
import 'package:app/widgets/platform_icons.dart';


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
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        PlatformIcons(supported: platformsSupported),
        const Icon(Icons.chevron_right_rounded),
      ]),
    );
  }

  static List<Example> paymentMethodScreens = [];

  static List<Widget> screens = [
    ExampleSection(title: 'Auth', children: [
      Example(
        title: 'Profile',
        builder: (c) => const ProfileForm(),
        platformsSupported: const [
          DevicePlatform.android,
          DevicePlatform.ios,
          DevicePlatform.web
        ],
      ),
    ]),
    ExampleSection(title: 'Payment Sheet', expanded: true, children: [
      Example(
        title: 'Single Step',
        builder: (context) => const PaymentSheetScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
    ])
  ];
}
