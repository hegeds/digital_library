import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final IconData iconData;
  final String text;
  final String route;

  const HomeCard(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pushNamed(context, route);
            },
            child: SizedBox(
              width: 200,
              height: 100,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(iconData), Text(text)],
              ),
            )));
  }
}
