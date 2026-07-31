import 'package:flutter/material.dart';
import 'package:module_clone/constants.dart';
import 'package:module_clone/widgets/nav_drawer.dart';

class MoodleScaffold extends StatelessWidget {
  const MoodleScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.backgroundColor = moodleBg,
    this.showDrawer = true,
    this.padding = const EdgeInsets.all(24),
    this.scrollable = true,
    this.maxContentWidth = 960,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Color backgroundColor;
  final bool showDrawer;
  final EdgeInsets padding;
  final bool scrollable;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxContentWidth,
          ),
          child: body,
        ),
      ),
    );

    if (scrollable) {
      content = SingleChildScrollView(
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: showDrawer ? const NavDrawer() : null,
      appBar: AppBar(
        backgroundColor: moodleWhite,
        foregroundColor: moodleTextDark,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/moodle_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: actions,
      ),
      body: content,
    );
  }
}