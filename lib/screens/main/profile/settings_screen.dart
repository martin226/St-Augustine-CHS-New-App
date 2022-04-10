import 'package:flutter/material.dart';
import 'package:staugustinechsnewapp/screens/layout/page_layout.dart';
import 'package:staugustinechsnewapp/styles.dart';
import 'package:staugustinechsnewapp/widgets/reusable/basic_container.dart';
import 'package:staugustinechsnewapp/widgets/reusable/screen_header.dart';

class SettingsScreen extends StatefulWidget {
  final void Function() onPressedLogout;
  final void Function() onPressedFAQ;

  const SettingsScreen(
      {Key? key, required this.onPressedLogout, required this.onPressedFAQ})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  Widget buildOptions() {
    return BasicContainer(
        child: Column(
      children: [
        TextButton(
            onPressed: widget.onPressedLogout,
            child: const Text('Log Out', style: Styles.normalSubText)),
      ],
    ));
  }

  Widget buildFAQ() {
    return BasicContainer(
        child: Row(
      children: [
        const Text('FAQ', style: Styles.normalMainText),
        const Spacer(),
        IconButton(
            onPressed: widget.onPressedFAQ,
            icon: const Icon(Icons.arrow_forward_rounded,
                color: Styles.secondary))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: [
        const ScreenHeader(headerText: 'Settings'),
        const SizedBox(height: Styles.mainSpacing),
        buildOptions(),
        const SizedBox(height: Styles.mainSpacing),
        buildFAQ(),
      ],
    );
  }
}