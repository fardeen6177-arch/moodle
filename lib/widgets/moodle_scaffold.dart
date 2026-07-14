import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/nav_drawer.dart';

class MoodleScaffold extends StatelessWidget {
  const MoodleScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.backgroundColor = moodleBg,
    this.showDrawer = true,
    this.padding = const EdgeInsets.all(24.0),
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
    final content = scrollable
        ? SingleChildScrollView(
            padding: padding,
            child: body,
          )
        : Padding(
            padding: padding,
            child: body,
          );

    final widthAwareBody = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: content,
      ),
    );

    return Scaffold(
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
                'images/moodle_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        actions: actions,
      ),
      drawer: showDrawer ? const NavDrawer() : null,
      body: Container(
        color: backgroundColor,
        child: widthAwareBody,
      ),
    );
  }
}
