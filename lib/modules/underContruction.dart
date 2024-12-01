import 'package:flutter/material.dart';

class UnderConstructionPage extends StatelessWidget {
  final String pageTitle;

  const UnderConstructionPage({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(pageTitle),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pageTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
