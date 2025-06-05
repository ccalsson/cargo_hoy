import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformAwareScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const PlatformAwareScaffold({
    required this.title,
    required this.body,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
        trailingActions: actions,
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}

class PlatformAwareButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const PlatformAwareButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Theme.of(context).primaryColor : null,
        ),
      ),
      cupertino: (_, __) => CupertinoElevatedButtonData(
        color: isPrimary ? Theme.of(context).primaryColor : null,
      ),
    );
  }
}
