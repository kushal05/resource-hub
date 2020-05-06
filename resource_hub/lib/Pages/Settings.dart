import 'package:flutter/material.dart';
import 'package:resourcehub/Globals.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var icon_color= Colors.blue.shade200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text("Settings"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsetsDirectional.only(end: 16),
              child: Icon(Icons.brightness_2)
          )

        ],
      ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            children: <Widget>[

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading:  Icon(
                      Icons.brightness_2,
                      color: icon_color
                  ),
                  trailing: Switch(
                    value: darkThemeEnabled, 
                    onChanged: (value){
                      darkThemeEnabled=value;
                      setState(() {
                        setTheme(darkThemeEnabled);
                      });
                      // ignore: deprecated_member_use_from_same_package
                      AppBuilder.of(context).rebuild();
                    },
                  ),
                  title: Text("Dark Mode"),
                  ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading:  Icon(
                      Icons.build,
                      color: icon_color
                  ),
                  title: Text("Account"),
                  subtitle: Text("change account, privacy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                      Icons.exit_to_app,
                      color: icon_color
                  ),
                  title: Text("Logout"),
                  subtitle: Text("change account, privacy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                      Icons.notifications,
                      color: icon_color
                  ),
                  title: Text("Notifications"),
                  subtitle: Text("turn on and off app notifications"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                      Icons.bug_report,
                      color: icon_color
                  ),
                  title: Text("Bug Report"),
                  subtitle: Text("change account, privacy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                    Icons.help,
                    color: icon_color,
                  ),
                  title: Text("Help"),
                  subtitle: Text("FAQ,contact us,privacy policy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final RenderBox box = context.findRenderObject();

                  Share.share("Hey! Checkout this cool new app called ResourceHub",
                      subject: "Hey! Checkout this cool new app called ResourceHub",
                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                },
                child: ListTile(
                    leading: Icon(
                      Icons.people,
                      color: icon_color,
                    ),
                    title: Text("Invite a friend")
                ),
              ),

            ],
          ),
        )
    );
  }

  void setTheme(bool darkThemeEnabled) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', darkThemeEnabled);
    print("Setting dark theme as: $darkThemeEnabled");
  }
}
