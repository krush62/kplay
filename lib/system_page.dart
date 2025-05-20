
import 'dart:io';

import 'package:flutter/material.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage>
{
  final double _bottomIconSize = 48.0;

  void _onExit()
  {
    exit(0);
  }

  void _onShutdown()
  {

  }


  @override
  Widget build(final BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton.filled(
              onPressed: _onExit,
              icon: Icon(Icons.logout, size: _bottomIconSize),
          ),
          IconButton.filled(
              onPressed: _onShutdown,
              icon: Icon(Icons.power_settings_new, size: _bottomIconSize),
          ),
        ],
    );
  }
}
