import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  String? _permissionStatus;
  @override
  void initState() {
    super.initState();
    _getCurrentSoundMode();
    _getPermissionStatus();
  }

  Future<void> _getCurrentSoundMode() async {
    RingerModeStatus ringerStatus = RingerModeStatus.unknown;

    Future.delayed(const Duration(seconds: 1), () async {
      try {
        ringerStatus = await SoundMode.ringerModeStatus;
      } catch (err) {
        ringerStatus = RingerModeStatus.unknown;
      }

      setState(() {
        _soundMode = ringerStatus;
      });
    });
  }

  Future<void> _getPermissionStatus() async {
    bool? permissionStatus = false;
    try {
      permissionStatus = await PermissionHandler.permissionsGranted;
      print(permissionStatus);
    } catch (err) {
      print(err);
    }

    setState(() {
      _permissionStatus =
          permissionStatus! ? "Permissions Enabled" : "Permissions not granted";
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Running on: $_soundMode'),
            Text('Permission status: $_permissionStatus'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCurrentSoundMode(),
              child: Text('Get current sound mode'),
            ),
            ElevatedButton(
              onPressed: () => _setNormalMode(),
              child: Text('Set Normal mode'),
            ),
            ElevatedButton(
              onPressed: () => _setSilentMode(),
              child: Text('Set Silent mode'),
            ),
            ElevatedButton(
              onPressed: () => _setVibrateMode(),
              child: Text('Set Vibrate mode'),
            ),
            ElevatedButton(
              onPressed: () => _openDoNotDisturbSettings(),
              child: Text('Open Do Not Access Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setSilentMode() async {
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.silent);

      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Do Not Disturb access permissions required!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _setNormalMode() async {
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.normal);
      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Do Not Disturb access permissions required!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _setVibrateMode() async {
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.vibrate);

      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Do Not Disturb access permissions required!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _openDoNotDisturbSettings() async {
    await PermissionHandler.openDoNotDisturbSetting();
  }
}
