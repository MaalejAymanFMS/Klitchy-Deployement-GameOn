import 'package:flutter/material.dart';
import 'gestion_de_table.dart';
import 'dart:html' as html;

class FullScreenMode extends StatelessWidget {
  void _enterFullScreen() {
    if (html.document.documentElement?.requestFullscreen != null) {
      html.document.documentElement?.requestFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return (width < 1681 && height < 892)
        ? GestureDetector(
            onTap: () {
              _enterFullScreen();
            },
            child: const Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Ghassen bro ! this screen is to oblige them to work only in full screen mode! so be creative put any design you want in this screen "),
                ],
              ),
            ),
          )
        : const GestionDeTable();
  }
}
