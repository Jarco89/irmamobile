import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/change_pin/change_pin_screen.dart';
import 'package:irmamobile/src/screens/settings/widgets/settings_header.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _longPin = false;
  bool _startQRScan = false;
  bool _reportErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, 'settings.title'))),
      //drawer: NavigationDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Theme.of(context).canvasColor,
        child: ListView(children: <Widget>[
          SettingsHeader(headerText: FlutterI18n.translate(context, 'settings.pin.header')),
          SwitchListTile(
            onChanged: (bool value) {
              setState(() {
                _longPin = value;
              });
            },
            title:
                Text(FlutterI18n.translate(context, 'settings.pin.header'), style: Theme.of(context).textTheme.body1),
            value: _longPin,
            subtitle: Text(
              FlutterI18n.translate(context, 'settings.pin.long_pin'),
              style: const TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(ChangePinScreen.routeName);
            },
            title: Text(
              FlutterI18n.translate(context, 'settings.pin.change_pin'),
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(IrmaIcons.arrowFront),
          ),
          const Divider(),
          SettingsHeader(headerText: FlutterI18n.translate(context, 'settings.behavior.header')),
          SwitchListTile(
            title: Text(
              FlutterI18n.translate(context, 'settings.behavior.start_qr'),
              style: Theme.of(context).textTheme.body1,
            ),
            value: _startQRScan,
            onChanged: (bool value) {
              setState(() {
                _startQRScan = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(
              FlutterI18n.translate(context, 'settings.behavior.report_errors'),
              style: Theme.of(context).textTheme.body1,
            ),
            value: _reportErrors,
            onChanged: (bool value) {
              setState(() {
                _reportErrors = value;
              });
            },
          ),
          const Divider(),
          SettingsHeader(
            headerText: FlutterI18n.translate(context, 'settings.advanced.header'),
          ),
          ListTile(
            title: Text(
              FlutterI18n.translate(context, 'settings.advanced.delete'),
              style: Theme.of(context).textTheme.body1,
            ),
            subtitle: Text(
              FlutterI18n.translate(context, 'settings.advanced.delete_details'),
              style: const TextStyle(
                fontSize: 15.0,
              ),
            ),
            trailing: Icon(IrmaIcons.delete),
            onTap: () {
              debugPrint("Confirmation message"); // TODO confirmation message
            },
          ),
        ]),
      ),
    );
  }
}
